ARG ruby_version=3

FROM ruby:$ruby_version AS pagy-dev

RUN apt-get update && apt-get install --no-install-recommends -y locales \
 && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen \
 && apt-get install --no-install-recommends -y \
        git \
        nano \
        libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
        libcanberra-gtk* \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

ARG user
ARG group
ARG uid
ARG gid
ARG password=rubydev
ARG term=xterm-256color
ARG node_version=v16.10.0

RUN mkdir /opt/node \
 && curl https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz \
        | tar xfJ - --strip-components 1 -C /opt/node

ENV \
    PATH=/opt/node/bin:${PATH} \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    LS_OPTIONS='--color=auto' \
    EDITOR=nano \
    SHELL=/bin/bash \
    TERM=$term \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# setup users and .bashrc
#   - same pasword for user and root
#   - color prompt for user and root
#   - create dirs and chown them
RUN groupadd --gid=$gid --force $group \
 && useradd --uid=$uid --gid=$gid --shell=/bin/bash --create-home $user \
 && echo $user:$password | chpasswd \
 && echo root:$password | chpasswd \
 && sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /home/$user/.bashrc \
 && sed -i 's/\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]/\\u \\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\] /' /home/$user/.bashrc \
 && echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/home/$user/.bash_history" >> /home/$user/.bashrc \
 && cp /home/$user/.bashrc /root/.bashrc \
 && mkdir -p \
        /home/$user/.config \
        /home/$user/.local/share \
        /pagy/node_modules \
 && touch /pagy/node_modules/.keep \
 && chown -R $uid:$gid \
        $BUNDLE_PATH \
        /home/$user \
        /pagy/node_modules
WORKDIR /pagy

VOLUME \
    /home/$user \
    $BUNDLE_PATH


# Stage for user customization. Add here what you may need
# and create your own a docker-compose.override.yml out of the
# docker-compose.override-example.yml.
FROM pagy-dev AS pagy-custom-dev
RUN apt-get update && apt-get install --no-install-recommends -y \
        docker.io \
 && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean -y


# Stage for enabling also hardware acceleration (WebGL) for NVIDIA cards: Host and container use nouveau driver.
# This is useful only if you want to use a browser installed in the container or shared from the host
FROM pagy-custom-dev AS pagy-custom-nouveau-dev
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
 && apt-get update && apt-get install --no-install-recommends -y \
        mesa-utils mesa-utils-extra xserver-xorg-video-nouveau \
 && rm -rf /var/lib/apt/lists/* && apt-get clean -y


# Stage for enabling also hardware acceleration (WebGL) for NVIDIA cards: Host and container use NVIDIA driver.
# This is useful only if you want to use a browser installed in the container or shared from the host
# IMPORTANT: you must run the setup-env.sh and rebuild this stage when you update the host's NVIDIA driver
FROM pagy-custom-dev AS pagy-custom-nvidia-dev
ARG nvidia_version
ADD https://http.download.nvidia.com/XFree86/Linux-x86_64/${nvidia_version}/NVIDIA-Linux-x86_64-${nvidia_version}.run /tmp/NVIDIA-installer.run
RUN apt-get update && apt-get install --no-install-recommends -y kmod \
 && nvidia_opts='--accept-license --no-runlevel-check --no-questions --no-backup --ui=none --no-kernel-module --no-nouveau-check' ; \
    sh /tmp/NVIDIA-installer.run -A | grep -q -- '--install-libglvnd'        && nvidia_opts="$nvidia_opts --install-libglvnd" ; \
    sh /tmp/NVIDIA-installer.run -A | grep -q -- '--no-nvidia-modprobe'      && nvidia_opts="$nvidia_opts --no-nvidia-modprobe" ; \
    sh /tmp/NVIDIA-installer.run -A | grep -q -- '--no-kernel-module-source' && nvidia_opts="$nvidia_opts --no-kernel-module-source" ; \
    sh /tmp/NVIDIA-installer.run $nvidia_opts || { echo 'ERROR: Installation of NVIDIA driver failed.' >&2 ; exit 1 ; } ; \
    rm /tmp/NVIDIA-installer.run \
 && apt-get remove -y kmod && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean -y
