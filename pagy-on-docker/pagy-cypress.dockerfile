FROM cypress/included:7.3.0

ARG user
ARG group
ARG uid
ARG gid

# configure this image to run as a user identical to your host USER
# move test runner binary folder to the user home directory
RUN apt-get update && apt-get install -y libcanberra-gtk* \
 && groupadd -g $gid $user \
 && useradd -r --no-log-init -u $uid -g $user $group \
 && install -d -m 0755 -o $user -g $user /home/$user \
 && rm -rf /opt/firefox /usr/bin/firefox \
 && ln -s /root/.cache /home/$user/.cache \
 && npm install --save-dev @cypress/snapshot html-validate cypress-html-validate

# make sure cypress looks in the right place
ENV CYPRESS_CACHE_FOLDER=/home/$user/.cache/Cypress

USER $user
RUN mkdir /home/node/.config
