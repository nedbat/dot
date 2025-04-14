Support files for utility Docker images.

A base image is created with base.dockerfile.  A second Dockerfile is needed to
finish building a safe usable image.  main.dockerfile is the simplest second
image, it removes sudo to lock it down.

To build an image::

    $ ./build.sh main

Running in a simple generic environment is::

    $ ~/docker/run.sh main
    File mappings:
      ~/coverage/trunk is at /cov
      here (/src/bugs/bug1646) is at /here
    (.bashrc)
    b @main@~ $

To make a custom image for a particular bug, make a new Dockerfile. For
example, bug1553.dockerfile::

    # Always start with these lines:
    FROM nedbat/base
    USER root
    RUN SUDO_FORCE_REMOVE=yes sudo -E apt-get remove -y sudo
    USER me
    WORKDIR /home/me

    # Bug-specific steps:
    RUN git clone --depth=1 https://github.com/FlexMeasures/flexmeasures
    WORKDIR flexmeasures

    # Create a virtualenv, and "activate" it.
    RUN python3.9 -m venv .venv
    ENV PATH=".venv/bin:$PATH"

    RUN make install-pip-tools
    RUN sed -i.bak 's/pip install -e/pip install -e ./' Makefile
    RUN make install-for-test

    # Use `|| true` so that failing tests won't stop Docker from making an image.
    RUN python3 -m pytest --cov=flexmeasures --cov-config .coveragerc || true

You can make this file in any directory, and work from there.
Then this builds the Docker image::

    $ mkcd /src/bugs/bug1553
    $ edit bug1553.dockerfile    # fill it with the Dockerfile stuff
    $ ~/docker/build.sh bug1553

Now you can run inside the container with this::

    $ ~/docker/run.sh bug1553
    File mappings:
      ~/coverage/trunk is at /cov
      here (/Users/nedbatchelder/docker) is at /here
    (.bashrc)
    b @bug1553@~/flexmeasures main ±
