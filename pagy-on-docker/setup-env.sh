cat > .env << EOF
USER=$(id -un)
GROUP=$(id -gn)
UID=$(id -u)
GID=$(id -g)
EOF
