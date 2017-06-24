# DOCKER-VERSION 17.03.0-ce
# VERSION 

FROM python:3.6
MAINTAINER Jan Nash <jnash@jnash.de>

ENV PYTHONUNBUFFERED 1

ARG APP_SOURCE_VOLUME_PATH

RUN \
apt-get update && \
apt-get install -y --no-install-recommends \
	binutils \
	gdal-bin \
	libgeos-c1 \
	libgeos-dev \
	libproj-dev && \
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir -p ${APP_SOURCE_VOLUME_PATH}
WORKDIR ${APP_SOURCE_VOLUME_PATH}

COPY ./content/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
