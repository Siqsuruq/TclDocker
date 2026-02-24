# Base Alpine Image with Tcl and Tcllib
# Global variables (defaults, overridable via --build-arg)
ARG TCL_HOME=/opt/tcl9
ARG TCL_LIB_HOME=/opt/tcl9/lib
ARG TCL_BIN_HOME=/opt/tcl9/bin
ARG TCLSH=tclsh9.0
ARG TCLVER=9.0.3
ARG TCLSHORTVER=9.0

# ===============================
# Stage 1: Build Tcl and Tcllib
# ===============================
FROM alpine:3.23 AS builder

# Re-declare args in this stage
ARG TCL_HOME
ARG TCL_LIB_HOME
ARG TCL_BIN_HOME
ARG TCLSH
ARG TCLVER
ARG TCLSHORTVER

# Build dependencies
RUN apk add --no-cache \
    bash ca-certificates musl-dev libbsd-dev curl wget git \
    build-base autoconf automake libtool \
    zlib-dev openssl-dev libpng-dev \
    linux-headers \
    postgresql-dev

# --- Build Tcl ---
WORKDIR /build/tcl
RUN wget -O "tcl${TCLVER}-src.tar.gz" \
      "https://sourceforge.net/projects/tcl/files/Tcl/${TCLVER}/tcl${TCLVER}-src.tar.gz/download" \
    && tar -xf "tcl${TCLVER}-src.tar.gz"

WORKDIR "/build/tcl/tcl${TCLVER}/unix"
RUN ./configure --prefix="${TCL_HOME}" --enable-64bit \
    && make -j"$(nproc)" \
    && make install

# --- Build TclTLS 2.0 ---
WORKDIR /build/tls
RUN wget -O tcltls-2.0.tar.gz https://core.tcl-lang.org/tcltls/uv/tcltls-2.0-src.tar.gz \
    && tar -xf tcltls-2.0.tar.gz \
    && rm tcltls-2.0.tar.gz
RUN cd tcltls-* \
    && ./configure --with-tcl="${TCL_LIB_HOME}" --prefix="${TCL_HOME}" \
        --with-openssl-dir=/usr \
        --with-openssl-includedir=/usr/include \
        --with-openssl-libdir=/usr/lib \
    && make -j"$(nproc)" \
    && make install

# --- Build tDOM 0.9.6 (XML/HTML Parser) ---
WORKDIR /build/tdom
RUN wget -O tdom-0.9.6.tgz http://tdom.org/downloads/tdom-0.9.6-src.tgz \
    && tar -xf tdom-0.9.6.tgz \
    && rm tdom-0.9.6.tgz
RUN cd tdom-* \
    && ./configure --with-tcl="${TCL_LIB_HOME}" --prefix="${TCL_HOME}" --enable-64bit \
    && make -j"$(nproc)" \
    && make install

# --- Build NSF (Next Scripting Framework) ---
WORKDIR /build/nsf
RUN git clone https://github.com/nm-wu/nsf.git .
RUN ./configure --with-tcl="${TCL_LIB_HOME}" --prefix="${TCL_HOME}" --enable-64bit \
    && make -j"$(nproc)" \
    && make install

# --- Build tzint 1.2 ---
WORKDIR /build/tzint
RUN wget -O tzint-1.2.tar.gz https://github.com/aschoepe/tzint/archive/refs/tags/version-1.2.tar.gz \
    && tar -xf tzint-1.2.tar.gz
WORKDIR /build/tzint/tzint-version-1.2
RUN ./configure --with-tcl="${TCL_LIB_HOME}" --prefix="${TCL_HOME}" --enable-64bit \
    && make -j"$(nproc)" \
    && make install

# --- Install Tcllib 2.0 (The Standard Library) ---
WORKDIR /build/tcllib
RUN wget -O tcllib-2.0.tar.gz https://core.tcl-lang.org/tcllib/uv/tcllib-2.0.tar.gz \
    && tar -xf tcllib-2.0.tar.gz
WORKDIR /build/tcllib/tcllib-2.0
RUN ./configure --prefix="${TCL_HOME}" \
    && "${TCL_BIN_HOME}/${TCLSH}" installer.tcl -pkg-path "${TCL_LIB_HOME}" -no-gui -no-wait -no-html

RUN ln -sf "${TCL_HOME}/bin/${TCLSH}" "${TCL_HOME}/bin/tclsh"

# ===============================
# Stage 2: Final Image
# ===============================
FROM alpine:3.23

# Re-declare args in this stage
ARG TCL_HOME
ARG TCL_LIB_HOME
ARG TCL_BIN_HOME
ARG TCLSH
ARG TCLVER
ARG TCLSHORTVER

# Runtime dependencies
RUN apk add --no-cache \
    ca-certificates zlib openssl libpng rlwrap libxml2-utils

# Copy Tcl tree
COPY --from=builder "${TCL_HOME}" "${TCL_HOME}"
ENV PATH="${TCL_BIN_HOME}:$PATH"

# Directory for user-provided Tcl packages
ENV TCL_EXTERNAL_LIBS=/external_libs
RUN mkdir -p "$TCL_EXTERNAL_LIBS"
ENV TCLLIBPATH="/external_libs"

CMD ["rlwrap", "tclsh"]

# Metadata using OCI Image Format Specification annotations
ARG BUILD_DATE
ARG VCS_REF
LABEL org.opencontainers.image.title="Alpine Tcl/Tcllib Image" \
    org.opencontainers.image.description="A custom Docker image with Alpine, Tcl ${TCLVER}, and Tcllib 2.0." \
    org.opencontainers.image.version="1.0.3" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.authors="admin@cloudz.cv" \
    org.opencontainers.image.vendor="Cloudz" \
    org.opencontainers.image.licenses="BSD-3-Clause" \
    org.opencontainers.image.url="https://github.com/Siqsuruq/TclDocker/tree/main/AlpineTclBaseImage" \
    org.opencontainers.image.documentation="https://github.com/Siqsuruq/TclDocker/tree/main/AlpineTclBaseImage" \
    org.opencontainers.image.source="https://github.com/Siqsuruq/TclDocker/tree/main/AlpineTclBaseImage"