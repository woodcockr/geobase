FROM buildpack-deps:bionic

ENV LC_ALL C.UTF-8

RUN apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
       python3-dev python3-pip python3-venv \
       fakeroot checkinstall


RUN pip3 install --no-cache --upgrade pip && hash -r && \
    pip3 install --no-cache setuptools wheel cython numpy

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
    cmake \
    sqlite3 \
    libjpeg-dev \
    libexpat-dev \
    libxerces-c-dev \
    libwebp-dev \
    libzstd1-dev \
    libnetcdf-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    libopenjp2-7-dev \
    libkml-dev \
    && rm -rf /var/lib/apt/lists/*

# dev conveniences
RUN apt-get update -y \
    && apt-get install -y --fix-missing --no-install-recommends \
    cmake-curses-gui \
    htop \
    tmux \
    sudo \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/build"]
VOLUME ["/dl"]

ARG USER_NAME=ubuntu
ARG UID=1000

RUN adduser --disabled-password --gecos '' -u ${UID} ${USER_NAME} \
    && adduser ${USER_NAME} sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER_NAME}
WORKDIR /build

COPY ./builder.sh /usr/local/bin/

CMD ["/bin/bash"]
