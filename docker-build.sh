#!/bin/bash
# Script to build yocto in a docker container
# Author: Samuel Gfrörer

BASE_DIR="$(dirname "$(readlink -f "$0")")"

# echo "BASE_DIR: '$BASE_DIR'"


USER_NAME=$(whoami)
USER_ID=$(id -u)
GROUP_ID=$(id -g)
SSH_PRV_KEY=($HOME/.ssh/id_rsa)
SSH_PUB_KEY=($HOME/.ssh/id_rsa.pub)

IMAGE_NAME="yocto-assignment-6"

INTERACTIVE=0

FLAGS="-d"
COMMAND="./build.sh"

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--interactive)
      INTERACTIVE=1
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

docker build -t "$IMAGE_NAME" \
	--build-arg USERNAME="$USER_NAME" \
	--build-arg PUID="$USER_ID" \
	--build-arg PGID="$GROUP_ID" \
	- < Dockerfile

if [[ $INTERACTIVE != "0" ]]; then
	FLAGS="-it"
	COMMAND="/bin/bash"
fi

	docker run $FLAGS \
		--volume "$BASE_DIR:/home/$USER_NAME/dev" \
		--volume "$BASE_DIR/../assignment-3-EsGeh:/home/$USER_NAME/src" \
		--volume "$HOME/.ssh/id_rsa:/home/$USER_NAME/.ssh/id_rsa:ro" \
		--volume "$HOME/.ssh/id_rsa.pub:/home/$USER_NAME/.ssh/id_rsa.pub:ro" \
		--mount type=bind,src=$SSH_AUTH_SOCK,target=/run/host-services/ssh-auth.sock \
    -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
		"$IMAGE_NAME" \
		$COMMAND
