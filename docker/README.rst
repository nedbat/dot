Support files for utility Docker images.  These files are git-managed in ~/dot.

A base image is created with base.dockerfile.  A second Dockerfile is needed to
finish building a safe usable image.  main.dockerfile is the simplest second
image, it removes sudo to lock it down.

To build an image::

    $ ./build.sh main

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
    RUN python3.9 -m pip install -r requirements/app.txt 
    RUN python3.9 -m pip install -r requirements/test.txt

    # Use `|| true` so that failing tests won't stop Docker from making an image.
    RUN python3.9 -m coverage run --branch --source=flexmeasures -m pytest flexmeasures || true

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
