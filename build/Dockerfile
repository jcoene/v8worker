FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y build-essential curl git python-dev subversion

RUN mkdir /build
WORKDIR /build

# Build v8
COPY build.sh /build/
WORKDIR /build
RUN /build/build.sh
