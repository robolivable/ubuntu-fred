# Ubuntu image for running fred (Forensic Registry EDitor)

FROM ubuntu:latest

#ARG PLATFORM=macos

WORKDIR /tmp/setup

ADD . /tmp/setup

RUN \
    # setup system
    apt update \
    && apt-get update \
    && apt install -y git make vim wget \
    && apt-get install -y autoconf automake build-essential libtool perl pkg-config python ruby \
    && apt-get install -y bsdtar ocaml libgl1-mesa-dev libxext-dev libxml2 libxml2-dev gettext \

    # install & configure x11 vnc server
    && apt-get install -y x11vnc xvfb \
    && mkdir /root/.vnc && x11vnc -storepasswd ubuntu /root/.vnc/passwd \

    # install Qt 4.x libraries
    && cd /tmp/setup \
    && cd qt-everywhere-opensource-src-4.8.7 \
    && ./configure -release -opensource -confirm-license -nomake tests && make && make install \
    && export PATH=$PATH:/usr/local/Trolltech/Qt-4.8.7/bin \
    && apt-get install -y qt4-default libqtwebkit-dev \

    # install hivex
    && cd /tmp/setup \
    && cd hivex \
    && ./autogen.sh && touch build-aux/config.rpath \
    && make && touch po/Makefile.in.in \
    && ./autogen.sh && make && make install \
    
    # install fred
    && cd /tmp/setup \
    && cd fred/trunk && ./autogen.sh --platform=linux && make && make install

CMD /tmp/setup/fred/trunk/fred
