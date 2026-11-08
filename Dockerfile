# Compiles nsjail from source (no prebuilt binaries exist - Google ships
# source-only releases). Final stage is the whole runtime, not just the
# binary - nsjail is dynamically linked against libprotobuf/libnl, and
# copying files individually risks missing a transitive dependency.
FROM debian:bookworm-slim AS base

RUN apt-get -y update && apt-get install -y \
    libc6 \
    libstdc++6 \
    libprotobuf32 \
    libnl-route-3-200

FROM base AS build

RUN apt-get install -y \
    autoconf \
    bison \
    flex \
    gcc \
    g++ \
    git \
    libprotobuf-dev \
    libnl-route-3-dev \
    libtool \
    make \
    pkg-config \
    protobuf-compiler

RUN git clone --depth 1 https://github.com/google/nsjail.git /nsjail \
    && cd /nsjail && make

FROM base AS run
COPY --from=build /nsjail/nsjail /bin/nsjail
