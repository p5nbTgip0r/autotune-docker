# Autotune Docker Image

_Docker image for running oref0-autotune_

### Information

This image is designed to allow you to run `oref0-autotune` ([docs](http://openaps.readthedocs.io/en/latest/docs/Customize-Iterate/autotune.html)) without needing to have a full copy of oref0 installed to your system. I made this image because oref0 can be quite heavy in terms of filesystem and dependency requirements for someone who wants to use the autotune portion of the system. In addition, the setup process can be quite tricky and time consuming if you're trying to use the autotune feature. By using a docker image for this we can make it simple to run as well as clean up afterwards.

This image works by downloading and installing [the packages required to run openaps](https://github.com/openaps/docs/blob/master/scripts/quick-packages.sh) then using npm to install the latest version of [oref0](https://github.com/openaps/oref0). The entrypoint script is designed to 

### Building the image

You can build this image by navigating into the directory that includes the `Dockerfile` and running 
```ssh
docker build -t autotune .
```

### Recommended setup

This will run autotune on the Nightscout server `https://mynightscout.azurewebsites.net` starting from June 1, 2018 and ending on June 5, 2018. This should give a good example for most people to start off with. 

```ssh
docker run \
    --rm -it
    --name=autotune \
    -e "START_DATE=2018-06-01" \
    -e "AUTOTUNE_PREFS=--end-date=2018-06-05" \
    -e "NS_HOST=https://mynightscout.azurewebsites.net" \
    -v $PWD/autotune:/data \
    autotune
```

### Getting recommendations

Assuming you created a volume for `/data` the recommendations will be output to `autotune_recommendations.log` in the volume. 

### Volumes

Providing a volume at `/data` in the container will automatically link and use these files and directories. The currently supported files are:
* `autotune_recommendations.log` - the output of autotune (will be overwritten automatically) 
* `profile.json` - file telling autotune what settings your pump uses currently. Instructions for how to make this file can be found [here, scrolling down to step 3](http://openaps.readthedocs.io/en/latest/docs/Customize-Iterate/autotune.html#phase-c-running-autotune-for-suggested-adjustments-without-an-openaps-rig)

```sh
docker run \
	--name=autotune \
	-v /host/path:/data \
	autotune
```

### Environment variables

This image works mainly through environment variables. These can be passed through `docker run` by adding `-e` followed by the variable declaration. As an example, adding this to the `docker run` command will set the Nightscout API secret to `hunter2`: `-e "API_SECRET=hunter2"`
The currently supported variables are:
* `NS_HOST` - Required: URL of your Nightscout website to run autotune on. Do not leave a leading slash, it should end with the TLD and nothing more
* `START_DATE` - Required: date of where to run autotune from in YYYY-MM-DD format
* `API_SECRET` - API secret of your Nightscout website
* `AUTOTUNE_PREFS` - Extra command line options to pass along to autotune. More information can be found [below](#additional-autotune-preferences)

### Additional autotune preferences

Autotune permits some additional command line preferences that are not handled by this image. You can specify them under the `AUTOTUNE_PREFS` environment variable

```sh
docker run \
  --name=autotune \
  -e "AUTOTUNE_PREFS=--end-date=2018-06-05" \
	autotune
```

### Troubleshooting

First check the [troubleshooting page](http://openaps.readthedocs.io/en/latest/docs/Customize-Iterate/autotune.html#why-isn-t-it-working-at-all) provided by OpenAPS. Please don't bother the OpenAPS contributors about setup issues since this docker image this is not supported or created by them.
