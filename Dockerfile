FROM node:latest

# Install requirements and clean up after ourselves
RUN apt-get -q update \
  && apt-get -qy install git-core redis-server \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install hubot and related
RUN npm install -g hubot yo generator-hubot coffee-script

# Setup a user to run as
RUN adduser --disabled-password --gecos "" yeoman
USER yeoman
WORKDIR /home/yeoman

# Clone the slack adapter because current released one has a bug in
# sending messages direct to people hubot hasn't spoken to before
RUN git clone https://github.com/slackhq/hubot-slack/

# Create hubot
RUN yo hubot --name hubot --description "Rewardle Hubot" --adapter slack --defaults

# Default command to start up with
CMD bin/hubot --adapter slack
