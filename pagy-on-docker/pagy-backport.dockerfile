FROM ruby:2.7

ARG term
ENV TERM="${term:-xterm-256color}"

# install required packages
RUN apt-get update && apt-get install -y locales \
 && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen \
 && apt-get install -y \
        nodejs \
        git \
        nano

ARG user
ARG group
ARG uid
ARG gid
ARG password=rubydev

# setup users and .bashrc
#   - same pasword for user and root
#   - color prompt for user and root
RUN groupadd --gid=$gid --force $group \
 && useradd --uid=$uid --gid=$gid --shell=/bin/bash --create-home $user \
 && echo $user:$password | chpasswd \
 && echo root:$password | chpasswd \
 && sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /home/$user/.bashrc \
 && sed -i 's/\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]/\\u \\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\] /' /home/$user/.bashrc \
 && echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/home/$user/.bash_history" >> /home/$user/.bashrc \
 && cp /home/$user/.bashrc /root/.bashrc

ENV \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_CACHE_ALL=1 \
    LS_OPTIONS='--color=auto' \
    EDITOR=nano \
    TERM=${term:-xterm-256color} \
    SHELL=/bin/bash \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN chown -R $uid:$gid $BUNDLE_PATH

WORKDIR /opt/project

VOLUME \
    /home/$user \
    $BUNDLE_PATH

USER $user
