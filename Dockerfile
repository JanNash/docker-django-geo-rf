# DOCKER-VERSION 17.06.0-ce
# VERSION 

FROM python:3.6-stretch
MAINTAINER Jan Nash <jnash@jnash.de>

ENV PYTHONUNBUFFERED 1

ARG APP_SOURCE_VOLUME_PATH

RUN \
apt-get update && \
apt-get install -y --no-install-recommends \
	binutils \
	gdal-bin \
    libgeoip1 \
	libgeos-dev \
    libgeo-proj4-perl \
    python-gdal && \
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir -p ${APP_SOURCE_VOLUME_PATH}
WORKDIR ${APP_SOURCE_VOLUME_PATH}

COPY ./content/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
