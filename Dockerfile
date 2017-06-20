# DOCKER-VERSION 17.03.0-ce
# VERSION 

FROM python:3.6
MAINTAINER Jan Nash <jnash@jnash.de>

ENV PYTHONUNBUFFERED 1

ARG APP_SOURCE_VOLUME_PATH
ARG GEOS_VERSION
ARG PROJ4_VERSION
ARG PROJ4_DATUMGRID_VERSION
ARG GDAL_VERSION



# This run installs the following requirements/helpers:
# - GEOS
# - PROJ.4 (with extra datumgrid datumfiles)
# - GDAL
# For more information, see 
# https://docs.djangoproject.com/en/1.11/ref/contrib/gis/install/geolibs/
RUN \
apt-get update && \
# We only need unzip because datumgrid 1.6 is only available as zip...
apt-get install -y --no-install-recommends unzip && \
cd /tmp && \

# Install GEOS #
wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
tar xjf geos-${GEOS_VERSION}.tar.bz2 && \
rm geos-${GEOS_VERSION}.tar.bz2 && \
cd geos-${GEOS_VERSION} && \
./configure && \
make && \
make install && \
cd .. && \

# Install PROJ.4 #
wget http://download.osgeo.org/proj/proj-${PROJ4_VERSION}.tar.gz && \
# datumgrid 1.6 is only available as zip, not as tar.gz...
wget http://download.osgeo.org/proj/proj-datumgrid-${PROJ4_DATUMGRID_VERSION}.zip && \
tar xzf proj-${PROJ4_VERSION}.tar.gz && \
cd proj-${PROJ4_VERSION}/nad && \
unzip ../../proj-datumgrid-${PROJ4_DATUMGRID_VERSION}.zip && \
cd .. && \
./configure && \
make && \
make install && \
cd .. && \

# Install GDAL #
wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
tar xzf gdal-${GDAL_VERSION}.tar.gz && \
cd gdal-${GDAL_VERSION} && \
./configure && \
make && \
make install && \

# Cleanup
cd / && \
apt-get remove -y unzip && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*



RUN mkdir -p ${APP_SOURCE_VOLUME_PATH}
WORKDIR ${APP_SOURCE_VOLUME_PATH}

COPY ./content/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
