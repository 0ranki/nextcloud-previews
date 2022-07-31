# nextcloud-previews
## Nextcloud container with preinstalled video preview generation

These are container images built using the official Nextcloud Apache images as
source, adding the required packages to generate video previews and `supervisord`
to use `cron` inside the container.

I'll try to keep up with Nextcloud's upstream releases.
The build itself is automated, but requires a tag to be pushed before triggering,
so there may be a slight delay before a new image version is built. The plan is to
automate the whole process to automatically build images after upstream release.

## Usage
For instructions on using these images, go to https://github.com/nextcloud/docker
and https://docs.nextcloud.com/.

Simply use `ghcr.io/0ranki/nextcloud-previews/nextcloud:<version>`
instead of `docker.io/library/nextcloud`. At the moment the images don't use the `latest`
tag, so you'll need to use a specific version.

To pull e.g. version 24.0.3:
```
podman pull ghcr.io/0ranki/nextcloud-previews/nextcloud:24.0.3
```

The images have a convenience script installed that modifies `config.php` to actually
enable the video preview generation. To use it, finish the first run wizard first, then

```
podman run <name-of-nc-container> enable-previews
```
if using podman. If using docker substitute `podman` with `docker`. The script makes
a backup copy of `config.php` starting from versions 23.0.7 and 24.0.3 (noticed that
feature missing a bit late)
## Disclaimer
Nextcloud is a registered trademark of Nextcloud GmbH, and I am in no way affiliated
with them. These images are built for personal use and for learning GitHub actions.