# yocto assignment 6

## Install

If you are not on a platform officially supported by yocto, you might choose one of the following options:

- Build with docker
- Try to build natively: install deps, downgrade packages (ie python, gcc), if necessary

### Docker

Build image with docker:

    $ ./docker-build.sh

Run test inside docker:

    $ ./docker-build.sh -i
    (docker) $ ./full-test.sh
