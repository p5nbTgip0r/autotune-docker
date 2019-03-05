FROM node:alpine

################
# These variables are here as a list of what variables are used/checked
# Please modify them using `-e "env=value"` and NOT by modifying this file
################
# The image will not work without these set
ENV NS_HOST="https://mynightscout.azurewebsites.net"
ENV START_DATE="YYYY-MM-DD"

# Optional: Extra preferences to pass along when running `oref0-autotune`
# Example: -e "AUTOTUNE_PREFS=--end-date=2018-06-15" 
ENV AUTOTUNE_PREFS=""

# Optional, only necessary if your NS is set to disallow anonymous read access
ENV API_SECRET=""

################

RUN apk update && apk add bash bc curl git jq && \
      mkdir -p /openaps/settings /openaps/autotune && chown node /openaps/*
COPY ./oref0 /oref0
WORKDIR /oref0
RUN npm install -g

COPY entrypoint.sh /entrypoint.sh
USER node
CMD ["/entrypoint.sh"]
