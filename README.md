# nextcloud-previews
## Nextcloud container with preinstalled video preview generation

These are container images built using the official Nextcloud Apache images as
source, adding the required packages to generate video previews.

A daily build runs from the master branch. [![Automatic Build](https://github.com/0ranki/nextcloud-previews/actions/workflows/daily.yml/badge.svg)](https://github.com/0ranki/nextcloud-previews/actions/workflows/daily.yml)

I strongly recommend using a specific major version in your docker-compose, kube YAML files or scripts. This will avoid accidentally updating your instance.

## Usage

[Running using Podman Kube YAML](PODMAN.md)

[Running the Podman pod as a service with systemd](SYSTEMD.md)

For detailed instructions on using these images, go to https://github.com/nextcloud/docker
and https://docs.nextcloud.com/.

Simply use `ghcr.io/0ranki/nextcloud-previews/nextcloud:<version>`
instead of `docker.io/library/nextcloud`.

### `latest` currently points to 27.1.x

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
