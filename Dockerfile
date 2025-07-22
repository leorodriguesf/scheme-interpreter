# STklos Dockerfile
#
# Build an STklos image on top of Alpine Linux
#
# From: https://github.com/egallesio/STklos/blob/master/etc/Docker/Dockerfile.stable

# To build the image
#    $ docker build -t stklos .  
#
# To run the image:
#    $ docker run -ti -v $(pwd):/home stklos

# ---------- Build stage
FROM alpine:3.15 AS build
RUN apk update && \
    apk add build-base gc-dev gmp-dev libffi-dev pcre2-dev git

WORKDIR /build
RUN wget https://stklos.net/download/stklos-2.10.tar.gz
RUN tar xvfz stklos-2.10.tar.gz

WORKDIR /build/stklos-2.10
RUN env CFLAGS=-O3 ./configure \
    --without-provided-bignum \
    --without-provided-gc     \
    --without-provided-regexp \
    --without-provided-ffi
RUN env TERM="dumb" make all tests install

# ---------- Running stage
FROM alpine:3.15
RUN apk update && \
    apk add gc gmp libffi pcre2 readline
COPY --from=build /usr/local/ /usr/local/
RUN ln -s /usr/lib/libreadline.so.8.1 /usr/lib/libreadline.so
WORKDIR /home
CMD ["stklos", "--utf8-encoding=yes"]
