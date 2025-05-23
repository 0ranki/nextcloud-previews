
ARG NEXTCLOUD_UPSTREAM_VERSION
FROM docker.io/library/nextcloud:${NEXTCLOUD_UPSTREAM_VERSION}

RUN apt-get update && \
    apt-get install -y \
	ffmpeg \
	libmagickcore-6.q16-6-extra \
	aria2 \
	poppler-utils &&\
	apt clean &&\
    rm -rf /var/lib/apt/lists/*

COPY $GITHUB_WORKSPACE/enable-previews /usr/local/bin
COPY $GITHUB_WORKSPACE/previews.conf /
COPY $GITHUB_WORKSPACE/dbup.sh /docker-entrypoint-hooks.d/post-installation/
COPY $GITHUB_WORKSPACE/dbup.sh /docker-entrypoint-hooks.d/post-upgrade/

RUN chmod +x /docker-entrypoint-hooks.d/post-installation/dbup.sh && chmod +x /docker-entrypoint-hooks.d/post-upgrade/dbup.sh

ENV NEXTCLOUD_UPDATE=1
