cat > .env << EOF
USER=$(id -un)
GROUP=$(id -gn)
UID=$(id -u)
GID=$(id -g)
TERM=xterm-256color
PASSWORD=rubydev
RUBY_VARIANT=3
EOF
