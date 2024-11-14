FROM node:latest

# Install requirements and clean up after ourselves

# Possible fix for this error : The repository 'http://security.debian.org/debian-security stretch/updates Release' does not have a Release file.
## Switch to archive repositories and update package lists
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get -y upgrade
    
RUN apt-get -q update \
  && apt-get -qy install git-core redis-server \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install hubot and related
RUN npm install -g hubot yo generator-hubot coffeescript@1.12.7 hubot-scripts hubot-slack

# Setup a user to run as
RUN adduser --disabled-password --gecos "" yeoman
USER yeoman
WORKDIR /home/yeoman

# Create hubot
RUN yo hubot --name hubot --description "Rewardle Hubot" --adapter slack --defaults
ENV NODE_PATH /home/yeoman/node_modules

# Default command to start up with
CMD bin/hubot --adapter slack
