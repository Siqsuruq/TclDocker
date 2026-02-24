# About TclDocker

This repository contains a collection of production-ready Docker images designed for various purposes. 
Each image is organized into its own directory, where you can find the Dockerfile and additional resources required to build the image.

This repository contains three OS variants:

-   Alpine (musl-based minimal image)
-   Debian (glibc-based stable server image)
-   Ubuntu (glibc-based Ubuntu ecosystem image)

------------------------------------------------------------------------

## DockerHub Prebuilt images
Prebuilt images are available on **Docker Hub**. You can pull them directly without building locally:
👉 https://hub.docker.com/r/siqsuruq/tcl

For example to run debian based image with Tcl9, simply do:
```bash
docker run --rm -it siqsuruq/tcl:tcl9-debian
```

------------------------------------------------------------------------

## Included Packages

Each image compiles and installs:

-   [Tcl 9.x or Tcl 8.x](https://www.tcl-lang.org/software/tcltk/download.html)
-   [TclTLS 2.0](https://core.tcl-lang.org/tcltls/home)
-   [tDOM 0.9.6](https://www.tdom.org/index.html)
-   [NSF (Next Scripting Framework / NX) 2.4.0](https://next-scripting.org/xowiki/)
-   [tzint 1.2](https://fossil.sowaswie.de/tzint/home)
-   [Tcllib 2.0](https://core.tcl-lang.org/tcllib/doc/trunk/embedded/md/toc.md)

------------------------------------------------------------------------

## External Tcl Packages

The image provides a dedicated directory inside of container for user-supplied Tcl packages:

```bash
/external_libs
```
This directory is exposed to Tcl through the `TCLLIBPATH` environment variable.

To use external packages, mount a local directory into the container:

```bash
docker run --rm -it -v "$PWD/external_libs:/external_libs" siqsuruq/tcl:tcl9-debian
```
Your mounted directory should contain standard Tcl package layouts, including a `pkgIndex.tcl`.

Inside the container:


```tcl
puts $::env(TCLLIBPATH)
```

By default, `TCLLIBPATH` is set to:
```
/external_libs
```
Any valid Tcl package placed in this directory will be discoverable via `package require`.

------------------------------------------------------------------------

## Build Instructions

Each image directory contains a `build.sh` script.

The script:

- Sets required build arguments (`BUILD_DATE`, `VCS_REF`)
- Builds the image using the correct Dockerfile
- Applies both moving and versioned tags
- Pushes the image to Docker Hub (if configured)

To build an image:

```bash
./build.sh
```

------------------------------------------------------------------------

## License

MIT
