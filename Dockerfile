FROM debian:jessie

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

COPY entrypoint.sh /entrypoint.sh

ADD https://raw.githubusercontent.com/openaps/docs/master/scripts/quick-packages.sh /tmp/

RUN mkdir -p "/root/myopenaps/settings" \
    && mkdir -p "/root/myopenaps/autotune" \
    && mkdir -p "/data/" \
    && touch "/root/myopenaps/settings/profile.json" \
    && touch "/root/myopenaps/autotune/autotune_recommendations.log" \
    && touch "/data/profile.json" \
    && chmod +x "/tmp/quick-packages.sh" \
    && chmod +x "/entrypoint.sh" \
    && apt-get update \
    && apt-get install -y sudo curl

RUN /tmp/quick-packages.sh \
    && npm list -g oref0 | egrep oref0@0.5.[5-9] || (echo Installing latest oref0 package && sudo npm install -g oref0)

CMD [ "/entrypoint.sh" ]