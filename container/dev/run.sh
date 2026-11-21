
set -o errexit -o pipefail

ask() {
  local __answer=""
  if [[ -t 0 ]]; then
    printf '%s [%s]: ' "$1" "$2" >&2
    read -r __answer || true
  fi
  echo "${__answer:-$2}"
}

CONTAINER_RUN_NAME="dev"
CONTAINER_PUBLISH="127.0.0.1:10022:22"
CONTAINER_VOLUME="${HOME}/Develop:/root/dev"
CONTAINER_NETWORK="dev-net"
CONTAINER_IMAGE_NAME="dev"

CONTAINER_MEMORY="$( ask "Container memory" "12g" )"
CONTAINER_CPUS="$( ask "Container CPUs" "6" )"
CONTAINER_SUBNET="$( ask "Container network subnet (container gets .2)" "192.168.100.0/24" )"

mkdir -p "${CONTAINER_VOLUME%%:*}"

# A dedicated network holding only this container keeps its address stable.
if ! container network inspect "$CONTAINER_NETWORK" > /dev/null 2>&1; then
  container network create --subnet "$CONTAINER_SUBNET" "$CONTAINER_NETWORK"
fi

container run --name "$CONTAINER_RUN_NAME" \
  --network "$CONTAINER_NETWORK" \
  --publish "$CONTAINER_PUBLISH" \
  --volume "$CONTAINER_VOLUME" \
  --ssh --tty --detach \
  --memory "$CONTAINER_MEMORY" \
  --cpus "$CONTAINER_CPUS" \
  "$CONTAINER_IMAGE_NAME"

unset CONTAINER_RUN_NAME
unset CONTAINER_PUBLISH
unset CONTAINER_VOLUME
unset CONTAINER_NETWORK
unset CONTAINER_SUBNET
unset CONTAINER_MEMORY
unset CONTAINER_CPUS
unset CONTAINER_IMAGE_NAME
