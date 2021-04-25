FROM cypress/included:7.1.0

ARG user
ARG group
ARG uid
ARG gid

# configure this image to run as a user identical to your host USER
# move test runner binary folder to the user home directory
RUN groupadd -g $gid $user \
 && useradd -r --no-log-init -u $uid -g $user $group \
 && install -d -m 0755 -o $user -g $user /home/$user
 && ln -s /root/.cache /home/$user/.cache

# make sure cypress looks in the right place
ENV CYPRESS_CACHE_FOLDER=/home/$user/.cache/Cypress

USER $user
