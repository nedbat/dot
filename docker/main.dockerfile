# Finish the generic main image for general use.

FROM nedbat/base

USER root

RUN SUDO_FORCE_REMOVE=yes sudo -E apt-get remove -y sudo

USER me
WORKDIR /home/me
