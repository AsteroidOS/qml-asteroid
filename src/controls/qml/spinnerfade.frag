#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec4 sourceColor = texture(source, qt_TexCoord0);
    float alpha = 1.0;
    if (qt_TexCoord0.y < 0.2)
        alpha = qt_TexCoord0.y * 5.0;
    if (qt_TexCoord0.y > 0.8)
        alpha = (1.0 - qt_TexCoord0.y) * 5.0;
    fragColor = sourceColor * alpha * qt_Opacity;
}

