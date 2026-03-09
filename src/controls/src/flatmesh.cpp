/*
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <QOpenGLShaderProgram>
#include <QOpenGLFunctions>
#include <QSettings>
#include <QVector>

#include "flatmesh.h"
#include "flatmeshgeometry.h"

// Our Adreno drivers fail to load shaders that are too long so we have to be concise and skip
// every unnecessary character such as spaces, \n, etc... This is effectively one long line!
//
// GLES 2.0 (GLSL ES 1.00) lacks: in/out qualifiers, flat, and the % operator for integers.
// versionedShaderCode() injects "#define GLES2" for GLES 2.0 contexts so the #ifdef
// blocks below select the right syntax at compile time.

static const char *vertexShaderSource =
    // GLES2: attribute/varying; GLES3+: in/out with flat shading
    // imod() abstracts the missing % operator in GLSL ES 1.00
    "#ifdef GLES2\n"
    "attribute vec4 coord;"
    "attribute vec4 color;"
    "varying vec4 fragColor;"
    "int imod(int a,int b){return a-(a/b)*b;}"
    "\n#else\n"
    // Qt may inject "attribute" qualifiers; redirect them to "in" for GLES3+
    "#define attribute in\n"
    "in vec4 coord;"
    "in vec4 color;"
    "flat out vec4 fragColor;"
    "int imod(int a,int b){return a%b;}"
    "\n#endif\n"

    "uniform mat4 matrix;"
    "uniform float shiftMix;"
    "uniform int loopNb;"
    "uniform vec2 shifts[" FLATMESH_SHIFTS_NB_STR "];"

    "void main(){"
         // Two vertices can have the same coordinate (if they give different colors to 2 triangles)
         // However, they need to move in sync, so we hash their coordinates as an index for shifts
        "int xHash=int(coord.x*100.0);"
        "int yHash=int(coord.y*100.0);"
        "int shiftIndex=loopNb+xHash+yHash;"

         // Interpolate between (coord + shiftA) and (coord + shiftB) in the [-0.5, 0.5] domain
        "vec2 pos=coord.xy+mix(shifts[imod(shiftIndex,"   FLATMESH_SHIFTS_NB_STR ")],"
                              "shifts[imod(shiftIndex+1," FLATMESH_SHIFTS_NB_STR ")],"
                              "shiftMix);"

        // Apply scene graph transformations (FlatMesh position and size) to get the final coords
        "gl_Position=matrix*vec4(pos,0,1);"

        // Forward the color in the vertex attribute to the fragment shaders
        "fragColor=color;"
    "}";

static const char *fragmentShaderSource =
    "#ifdef GL_ES\n"
    "precision mediump float;"
    "\n#endif\n"

    // GLES2: varying + gl_FragColor; GLES3+: flat in + explicit out
    "#ifdef GLES2\n"
    "varying vec4 fragColor;"
    "void main(){gl_FragColor=fragColor;}"
    "\n#else\n"
    // flat disables interpolation: each pixel gets the color of the provoking vertex
    "flat in vec4 fragColor;"
    "out vec4 color;"
    "void main(){color=fragColor;}"
    "\n#endif";

static bool isGLES2()
{
    QOpenGLContext *ctx = QOpenGLContext::currentContext();
    return ctx->isOpenGLES() && ctx->format().majorVersion() < 3;
}

static QByteArray versionedShaderCode(const char *src)
{
    QOpenGLContext *ctx = QOpenGLContext::currentContext();
    if (ctx->isOpenGLES() && ctx->format().majorVersion() < 3)
        return QByteArrayLiteral("#version 100\n#define GLES2\n") + src;
    return (ctx->isOpenGLES()
            ? QByteArrayLiteral("#version 300 es\n")
            : QByteArrayLiteral("#version 330\n"))
              + src;
}

// This class wraps the FlatMesh vertex and fragment shaders
class SGFlatMeshMaterialShader : public QSGMaterialShader
{
public:
    SGFlatMeshMaterialShader() {}
    const char *vertexShader() const override {
        static QByteArray source = versionedShaderCode(vertexShaderSource);
        return source.constData();
    }
    const char *fragmentShader() const override {
        static QByteArray source = versionedShaderCode(fragmentShaderSource);
        return source.constData();
    }
    void updateState(const RenderState &state, QSGMaterial *newEffect, QSGMaterial *oldEffect) override {
        // On every run, update the animation state uniforms
        SGFlatMeshMaterial *material = static_cast<SGFlatMeshMaterial *>(newEffect);
        program()->setUniformValue(m_shiftMix_id, material->shiftMix());
        program()->setUniformValue(m_loopNb_id, material->loopNb());

        if (state.isMatrixDirty()) {
            // Vertices coordinates are always in the [-0.5, 0.5] range, modify QtQuick's projection matrix to do the scaling for us
            QMatrix4x4 combinedMatrix = state.combinedMatrix();
            combinedMatrix.scale(material->width(), material->height());
            combinedMatrix.translate(0.5, 0.5);
            combinedMatrix.scale(material->screenScaleFactor());
            program()->setUniformValue(m_matrix_id, combinedMatrix);
        }
        // Enable a mode such that 0xFFFF indices mean "restart a strip"
        // on GLES 2.0 this the 0xFFFF restart markers in the index buffer will be
        // result in visual corruption.
        if (!isGLES2())
            m_glFuncs->glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    }
    char const *const *attributeNames() const override {
        // Map attribute numbers to attribute names in the vertex shader
        static const char *const attr[] = { "coord", "color", nullptr };
        return attr;
    }
    void deactivate() override {
        if (!isGLES2())
            m_glFuncs->glDisable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    }
private:
    void initialize() override {
        // Seed the array of shifts with pre-randomized shifts
        program()->setUniformValueArray("shifts", flatmesh_shifts, flatmesh_shifts_nb, 2);
        // Get the ids of the uniforms we regularly update
        m_matrix_id = program()->uniformLocation("matrix");
        m_shiftMix_id = program()->uniformLocation("shiftMix");
        m_loopNb_id = program()->uniformLocation("loopNb");
        // Retrieve OpenGL functions available on all platforms
        m_glFuncs = QOpenGLContext::currentContext()->functions();
    }
    int m_matrix_id;
    int m_shiftMix_id;
    int m_loopNb_id;
    QOpenGLFunctions *m_glFuncs;
};

QSGMaterialShader *SGFlatMeshMaterial::createShader() const
{
    return new SGFlatMeshMaterialShader;
}

FlatMesh::FlatMesh(QQuickItem *parent) : QQuickItem(parent), m_geometry(QSGGeometry::defaultAttributes_ColoredPoint2D(), flatmesh_vertices_sz, flatmesh_indices_sz), m_geometryInitialized(false)
{
    // Don't overflow the item dimensions
    setClip(true);

    // Dilate the FlatMesh more or less on squared or round screens
    QSettings machineConf("/etc/asteroid/machine.conf", QSettings::IniFormat);
    m_material.setScreenScaleFactor(machineConf.value("Display/ROUND", false).toBool() ? 1.2 : 1.7);

    // Iterate over all vertices and assign them the coordinates of their base point from flatmesh_vertices
    QSGGeometry::ColoredPoint2D *vertices = m_geometry.vertexDataAsColoredPoint2D();
    for (int i = 0; i < flatmesh_vertices_sz; i++) {
        vertices[i].x = flatmesh_vertices[i].x();
        vertices[i].y = flatmesh_vertices[i].y();
    }
    // Copy the indices buffer (already in the right format)
    memcpy(m_geometry.indexData(), flatmesh_indices, sizeof(flatmesh_indices));

    // Give initial colors to the vertices
    setColors(QColor("#ffaa39"), QColor("#df4829"));


    // m_animation interpolates the shiftMix, a float between 0.0 and 1.0
    // This is used by the vertex shader as the mix ratio between two shifts
    m_animation.setStartValue(0.0);
    m_animation.setEndValue(1.0);
    m_animation.setDuration(4000);
    m_animation.setLoopCount(-1);
    m_animation.setEasingCurve(QEasingCurve::InOutQuad);
    QObject::connect(&m_animation, &QVariantAnimation::currentLoopChanged, [this]() {
        m_material.incrementLoopNb();
    });
    QObject::connect(&m_animation, &QVariantAnimation::valueChanged, [this](const QVariant& value) {
        m_material.setShiftMix(value.toFloat());
        update();
    });

    // Run m_animation depending on the item's visibility
    connect(this, SIGNAL(visibleChanged()), this, SLOT(maybeEnableAnimation()));
    setAnimated(true);

    // Tell QtQuick we have graphic content and that updatePaintNode() needs to run
    setFlag(ItemHasContents);
}

void FlatMesh::updateColors()
{
    // Iterate over all vertices and give them the rgb values of the triangle they represent
    // In the flat shading model we use, each triangle is colored by its last vertex
    QSGGeometry::ColoredPoint2D *vertices = m_geometry.vertexDataAsColoredPoint2D();
    for (int i = 0; i < flatmesh_vertices_sz; i++) {
        // Ratios are pre-calculated to save some computation, we just need to do the mix
        // We do the color blending on the CPU because center and outer colors change rarely
        // and it would be a waste of GPU time to re-calculate that in every vertex shader
        float ratio = flatmesh_vertices[i].z();
        float inverse_ratio = 1-ratio;
        vertices[i].r = m_centerColor.red()*inverse_ratio + m_outerColor.red()*ratio;
        vertices[i].g = m_centerColor.green()*inverse_ratio + m_outerColor.green()*ratio;
        vertices[i].b = m_centerColor.blue()*inverse_ratio + m_outerColor.blue()*ratio;
    }
    m_geometryDirty = true;
}

void FlatMesh::setColors(QColor center, QColor outer)
{
    if (center == m_centerColor && outer == m_outerColor)
        return;
    m_centerColor = center;
    m_outerColor = outer;
    updateColors();
    update();
}

void FlatMesh::setCenterColor(QColor c)
{
    setColors(c, m_outerColor);
}

void FlatMesh::setOuterColor(QColor c)
{
    setColors(m_centerColor, c);
}

void FlatMesh::maybeEnableAnimation()
{
    // Only run the animation if the item is visible. No point running the shaders if this is hidden
    if (isVisible() && m_animated)
        m_animation.start();
    else
        m_animation.pause();
}

void FlatMesh::setAnimated(bool animated)
{
    if (animated == m_animated)
        return;
    m_animated = animated;
    emit animatedChanged();
    maybeEnableAnimation();
}

void FlatMesh::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    // On resizes, tell the vertex shader about the new size so the transformation matrix compensates it
    m_material.setSize(newGeometry.width(), newGeometry.height());

    QQuickItem::geometryChanged(newGeometry, oldGeometry);
}

// Called by the SceneGraph on every update()
QSGNode *FlatMesh::updatePaintNode(QSGNode *old, UpdatePaintNodeData *)
{
    // On the very first render, a GL context is active. On GLES2, the index buffer
    // contains 0xFFFF primitive-restart markers which GLES2 doesn't understand —
    // it would treat them as vertex index 65535 (way out of bounds), causing a GPU fault.
    // Expand the triangle strips to plain GL_TRIANGLES instead.
    if (!m_geometryInitialized) {
        m_geometryInitialized = true;
        if (isGLES2()) {
            QVector<unsigned short> triIdx;
            int i = 0;
            while (i < flatmesh_indices_sz) {
                int start = i;
                while (i < flatmesh_indices_sz && flatmesh_indices[i] != 0xFFFF)
                    ++i;
                int len = i - start;
                ++i; // skip the 0xFFFF restart marker
                // GL_TRIANGLE_STRIP alternates winding on odd triangles; match that in GL_TRIANGLES
                for (int j = 0; j < len - 2; ++j) {
                    if (j % 2 == 0)
                        triIdx << flatmesh_indices[start+j] << flatmesh_indices[start+j+1] << flatmesh_indices[start+j+2];
                    else
                        triIdx << flatmesh_indices[start+j+1] << flatmesh_indices[start+j] << flatmesh_indices[start+j+2];
                }
            }
            m_geometry.allocate(flatmesh_vertices_sz, triIdx.size());
            m_geometry.setDrawingMode(QSGGeometry::DrawTriangles);
            // allocate() resets the buffer, so re-initialize vertices and colors
            QSGGeometry::ColoredPoint2D *verts = m_geometry.vertexDataAsColoredPoint2D();
            for (int j = 0; j < flatmesh_vertices_sz; ++j) {
                verts[j].x = flatmesh_vertices[j].x();
                verts[j].y = flatmesh_vertices[j].y();
            }
            memcpy(m_geometry.indexData(), triIdx.constData(), triIdx.size() * sizeof(unsigned short));
            updateColors(); // re-applies vertex color attributes after re-allocation
        }
    }

    // On the first update(), create a scene graph node for the mesh
    QSGGeometryNode *n = static_cast<QSGGeometryNode *>(old);
    if (!n) {
        n = new QSGGeometryNode;
        n->setOpaqueMaterial(&m_material);
        n->setGeometry(&m_geometry);
    }

    // On every update(), mark the material dirty so the shaders run again
    n->markDirty(QSGNode::DirtyMaterial);
    // And if colors changed, mark the geometry dirty so the new vertex attributes are sent to the GPU
    if (m_geometryDirty) {
        n->markDirty(QSGNode::DirtyGeometry);
        m_geometryDirty = false;
    }

    return n;
}
