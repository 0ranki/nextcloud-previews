FROM docker.io/library/nextcloud:24.0.11

RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    libmagickcore-6.q16-6-extra \
	smbclient &&\
	apt clean &&\
    rm -rf /var/lib/apt/lists/*

COPY $GITHUB_WORKSPACE/enable-previews /usr/local/bin
COPY $GITHUB_WORKSPACE/previews.conf /

ENV NEXTCLOUD_UPDATE=1
