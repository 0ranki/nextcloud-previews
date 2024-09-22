# nextcloud-previews ![`latest` version](https://img.shields.io/github/v/tag/0ranki/nextcloud-previews) [![Daily build](https://github.com/0ranki/nextcloud-previews/actions/workflows/current.yml/badge.svg)](https://github.com/0ranki/nextcloud-previews/actions/workflows/current.yml)

## Nextcloud container with preinstalled video preview generation

These are container images built using the official Nextcloud Apache images as
source, adding the required packages to generate video previews.

Images are built daily using GitHub Actions.

I strongly recommend using a specific major version in your docker-compose, kube YAML files or scripts. This will avoid accidentally updating your instance.

### Update to the image name
Starting from version 27.1.4 the image is the same as the repo, **`ghcr.io/0ranki/nextcloud-previews`**

> **Tagging the old `ghcr.io/0ranki/nextcloud-previews/nextcloud` has been stopped.**

## Usage

[Running using Podman Kube YAML](PODMAN.md)

[Running the Podman pod as a service with systemd](SYSTEMD.md)

For detailed instructions on using these images, go to https://github.com/nextcloud/docker
and https://docs.nextcloud.com/.

Simply use `ghcr.io/0ranki/nextcloud-previews:<version>`
instead of `docker.io/library/nextcloud`.

### `latest` currently points to 29.0.x
#### `next` currently points to 30.0.x

The latest version stays one version behind the current upstream latest image.
In addition to the `latest` tag, there's also the `next` tag, which is the latest released
Nextcloud version.

To pull e.g. version 27.1.4:
```
podman pull ghcr.io/0ranki/nextcloud-previews:27.1.4
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

<sup><sub>The github mirror is used to build the container images.
Mirrored from https://git.oranki.net/jarno/nextcloud-previews</sub></sup>
