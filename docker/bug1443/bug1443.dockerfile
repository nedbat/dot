FROM nedbat/base

ARG APT_INSTALL="apt-get install -y --no-install-recommends"

USER root

RUN sudo apt-get update
RUN sudo $APT_INSTALL \
        libcurl4-gnutls-dev \
        libgnutls28-dev
RUN SUDO_FORCE_REMOVE=yes sudo -E apt-get remove -y sudo

USER me
WORKDIR /home/me

RUN git clone --depth=1 https://github.com/seanxiaoyan/salt.git
RUN python3.9 -m pip install nox

WORKDIR salt

#RUN python -m nox -e "pytest-3.9(coverage=True)" -- tests/integration
