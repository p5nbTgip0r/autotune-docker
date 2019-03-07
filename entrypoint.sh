#!/bin/bash

if [[ -z "${START_DATE}" ]] || [ "$START_DATE" = "YYYY-MM-DD" ]; then
  echo "START_DATE variable is not set, please do so before using this image"
  exit
elif [[ -z "${NS_HOST}" ]] || [ "$NS_HOST" = "https://mynightscout.azurewebsites.net" ]; then
  echo "NS_HOST variable is not set, please do so before using this image"
  exit
fi

if [[ -z "${AUTOTUNE_PREFS}" ]] || [ "$AUTOTUNE_PREFS" = "" ]; then
  echo "No extra preferences supplied"
else
  echo "Extra preferences: [${AUTOTUNE_PREFS}]"
fi


if ! [[ -s /data/profile.json ]]; then
  echo "No profile.json detected, please specify a volume mount for '/data/' and create 'profile.json' in the mount"
  exit
else
  cp /data/profile.json /openaps/settings/profile.json
  cp /data/profile.json /openaps/settings/pumpprofile.json
  cp /data/profile.json /openaps/settings/autotune.json
fi

TIMEZONE="$(jq '.timezone' /data/profile.json | tr -d \")"
echo "TIMEZONE: ${TIMEZONE}"
if [[ "${TIMEZONE}" = "null" ]]; then
  echo "No timezone detected in profile, exiting as to not provide inaccurate results"
  exit
else
  if [[ -f /usr/share/zoneinfo/"${TIMEZONE}" ]]; then
    cp /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
  else
    echo "Nonexistent timezone specified, exiting"
    exit
  fi
fi

date
id
ls -l /data /openaps
oref0-autotune --dir=/openaps --ns-host="${NS_HOST}" --start-date="${START_DATE}" ${AUTOTUNE_PREFS}

if ! [[ -s /openaps/autotune/autotune_recommendations.log ]]; then
  echo "No recommendations found, perhaps the command failed?"
else
  cp /openaps/autotune/autotune_recommendations.log /data/autotune_recommendations.log
  cp /openaps/autotune/profile.json /data/autotune-profile.json
  echo "Recommendations copied to /data/autotune_recommendations.log, check your volume mount"
fi
