FROM ubuntu:jammy

ARG APT_INSTALL="apt-get install -y --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/New_York
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN \
    apt-get update && \
    $APT_INSTALL \
        build-essential \
        curl \
        git \
        gpg-agent \
        litecli \
        locales \
        python3-pip \
        software-properties-common \
        sudo \
        tzdata \
        vim \
        && \
    locale-gen en_US.UTF-8 && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    :

RUN \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    for v in 7 8 9 10 11 12; do \
        $APT_INSTALL python3.$v python3.$v-dev python3.$v-venv; \
    done && \
    :

# This makes the image smaller, but also means you can't install more stuff
# later.  Use `apt-get update` again to re-enable installation, and search
# https://packages.ubuntu.com/ to find what you need.
RUN \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    :

RUN \
    groupadd me && \
    useradd -g me -G sudo -s /usr/bin/zsh -m me && \
    :

USER me
WORKDIR /home/me

COPY dot.sh ./dot.sh
RUN \
    ./dot.sh && \
    echo "Stop the sudo instructions during login" > .hushlogin && \
    echo "xterm-256color-italic|xterm with 256 colors and italic,sitm=\E[3m,ritm=\E[23m,use=xterm-256color," > ./term.terminfo && \
    tic ./term.terminfo && \
    rm ./dot.sh ./term.terminfo && \
    :

RUN \
    PIP_REQUIRE_VIRTUALENV= python3 -m pip install virtualenvwrapper && \
    mkdir ~/.virtualenvs && \
    for d in \
        premkproject postmkproject initialize premkvirtualenv postmkvirtualenv \
        prermvirtualenv postrmvirtualenv predeactivate postdeactivate \
        preactivate postactivate get_env_details; do \
        mkdir ~/.virtualenvs/$d; \
    done && \
    :
