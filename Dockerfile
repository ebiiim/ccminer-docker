FROM nvidia/cuda:11.1.1-devel-ubuntu16.04

# install prerequisites
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    curl \
    git \
    libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential \
    gcc-5 g++-5
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 1

# git clone
RUN mkdir /work
WORKDIR /work
RUN git clone https://github.com/tpruvot/ccminer.git
WORKDIR /work/ccminer
# version: Dec 13, 2022 (branch: linux)
RUN git checkout 1eb8dc686cbd93bd1692a3ae1ca0840c9e6547e5

# build
RUN sed -i -e 's/make -j 4/make -j $(nproc)/' build.sh
# NVIDIA Ampere GPUs
RUN sed -i -e 's/compute_52/compute_80/g' Makefile.am && sed -i -e 's/sm_52/sm_80/g' Makefile.am
RUN ./build.sh


FROM nvidia/cuda:11.1.1-runtime-ubuntu16.04

# install prerequisites
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libjansson-dev libgomp1
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN useradd -m user
RUN mkdir /work && chown -R user:user /work
USER user
WORKDIR /work

# add bin
COPY --from=0 /work/ccminer/ccminer ./

ENTRYPOINT ["./ccminer"]

LABEL maintainer "Shunsuke Ise <ise@ebiiim.com>"
