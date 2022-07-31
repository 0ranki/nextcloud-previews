FROM docker.io/library/nextcloud:23.0.2

RUN apt-get update &&\
    apt-get install -y \
    supervisor \
    ffmpeg \
    libmagickcore-6.q16-6-extra &&\ 
    rm -rf /var/lib/apt/lists/* &&\
    mkdir /var/log/supervisord /var/run/supervisord

COPY $GITHUB_WORKSPACE/supervisord.conf /
COPY $GITHUB_WORKSPACE/enable-previews /usr/local/bin
COPY $GITHUB_WORKSPACE/previews.conf /

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
