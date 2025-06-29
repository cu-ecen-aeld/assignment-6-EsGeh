# - Inspired by: https://witekio.com/blog/5-steps-to-compile-yocto-using-docker-containers/
# - Important Hints on using ssh from inside a docker container: https://javorszky.co.uk/2023/11/02/use-your-ssh-key-with-a-passphrase-inside-a-docker-container/
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
	gawk \
	wget \
	git-core \
	diffstat \
	unzip \
	texinfo \
	gcc-multilib \
	build-essential \
	chrpath \
	socat \
	cpio \
	python \
	python3 \
	python3-pip \
	python3-pexpect \
	xz-utils \
	debianutils \
	iputils-ping \
	python3-git \
	python3-jinja2 \
	libegl1-mesa \
	libsdl1.2-dev \
	xterm \
	locales \
	vim \
	bash-completion \
	screen

RUN apt-get update && apt-get install -y \
	zstd \
	liblz4-tool \
	sshpass \
	netcat

ARG USERNAME=dev
ARG PUID=1000
ARG PGID=1000

RUN groupadd -g ${PGID} ${USERNAME} \
	&& useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} \
	&& mkdir /home/${USERNAME} \
	&& chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN mkdir .ssh
RUN ssh-keyscan github.com >> .ssh/known_hosts

RUN mkdir dev
WORKDIR dev
