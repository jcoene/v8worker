FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y build-essential curl git python-dev subversion

RUN mkdir /build
WORKDIR /build

# Get depot_tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH $PATH:/build/depot_tools

# Get v8
RUN fetch v8

# Build v8
WORKDIR /build/v8
RUN make x64.release GYPFLAGS="-Dv8_use_external_startup_data=0 -Dv8_enable_i18n_support=0 -Dv8_enable_gdbjit=0"

# Copy v8 files
RUN mkdir -p /build/libv8/linux /build/include/libplatform
RUN cp -a ./include/*.h /build/include/
RUN cp -a ./include/libplatform/*.h /build/include/libplatform/
RUN cp -a ./out/x64.release/obj.target/src/libv8_*.a /build/libv8/linux/

# Return to build dir
WORKDIR /build
