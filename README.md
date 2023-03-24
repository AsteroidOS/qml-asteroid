# QML Components for Asteroid

QML-Asteroid provides elements to develop applications for [AsteroidOS](http://asteroidos.org).

## Non-watch version
It's often convenient to develop on a desktop computer rather than directly on the watch.  For that reason, `qml-asteroid` also supports building a non-watch version.  To build and install it on a desktop computer, one can turn off the generation of the AsteroidApp class and the installation of CMake modules.  For example, in the project's main directory, we might execute this command:

```
cmake -DWITH_ASTEROIDAPP=OFF -DWITH_CMAKE_MODULES=OFF -S . -B desktop
```

This will create a directory `desktop` which will then contain all of the CMake-generated build scripts.  To build the modules:

```
cmake --build desktop -j
```

This tells CMake to build in the `desktop` directory and the `-j` tells it to use as many cores as possible to speed up the build.  Once this is done, one can install the modules on the computer:

```
sudo cmake --build desktop -j -t install
```

This uses `sudo` because root privileges are generally needed for installation.  The `-t install` tells CMake that the build target (that is, the goal) is `install` so the `org.asteroid.controls` and `org.asteroid.utils` QML modules will be installed in the correct location for the computer and may then be used, for example, in testing and developing watchfaces.
