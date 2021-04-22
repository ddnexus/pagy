FROM cypress/included:7.1.0

# the upstram dockerfile already provides a node user with UID 1000
# so we configure the image to run as that user
RUN ln -s /root/.cache /home/node/.cache

# make sure cypress looks in the right place
ENV CYPRESS_CACHE_FOLDER=/home/node/.cache/Cypress

USER node
