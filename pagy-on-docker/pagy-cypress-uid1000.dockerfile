FROM cypress/included:8.4.0

# the upstram dockerfile already provides a node user with UID 1000
# so we configure the image to run as that user
RUN apt-get update && apt-get install -y libcanberra-gtk* \
 && rm -rf /opt/firefox /usr/bin/firefox \
 && ln -s /root/.cache /home/node/.cache \
 && npm install --save-dev @cypress/snapshot html-validate cypress-html-validate

# make sure cypress looks in the right place
ENV CYPRESS_CACHE_FOLDER=/home/node/.cache/Cypress

USER node
RUN mkdir /home/node/.config
