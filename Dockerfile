# Ubuntu image for running fred (Forensic Registry EDitor)

FROM ubuntu:latest

ARG PLATFORM=macos

WORKDIR /tmp/setup

ADD . /tmp/setup

RUN \
    # setup system
    apt update \
    && apt-get update \
    && apt install -y git make vim wget \
    && apt-get install -y autoconf automake build-essential libtool perl pkg-config python ruby \
    && apt-get install -y bsdtar ocaml libxext-dev libxml2 gettext \

    # install & configure x11 vnc server
    && apt-get install -y x11vnc xvfb \
    && mkdir /root/.vnc && x11vnc -storepasswd ubuntu /root/.vnc/passwd \

    # install Qt 4.x libraries
    && cd /tmp/setup \
    && cd qt-everywhere-opensource-src-4.8.7 && ./configure -nomake tests && make && make install \
    && export PATH=$PATH:/usr/local/Trolltech/Qt-4.8.7/bin \

    # install hivex
    && cd /tmp/setup \
    && cd hivex && ./autogen.sh \
    
    # install fred
    && cd /tmp/setup \
    && cd fred/trunk && ./autogen.sh && make && make install

