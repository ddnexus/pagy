cat > .env << EOF
COMPOSE_PROJECT_NAME=pagy
USER=$(id -un)
GROUP=$(id -gn)
UID=$(id -u)
GID=$(id -g)
TERM=$TERM
PASSWORD=rubydev
RUBY_VERSION=3
NVIDIA_VERSION="$(head -n1 </proc/driver/nvidia/version | awk '{ print $8 }')"
EOF
echo 'The ".env"file has been generated.'
