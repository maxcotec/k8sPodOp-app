################
# Envs Image
# Image containing all base environment requirements
################

FROM python:3.8-slim as envs
LABEL maintainer="Maxcotec <maxcotec.com/learning>"

# Set arguments to be used throughout the image
ARG OPERATOR_HOME="/home/op"
# Bitbucket-pipelines uses docker v18, which doesn't allow variables in COPY with --chown, so it has been statically set where needed.
# If the user is changed here, it also needs to be changed where COPY with --chown appears
ARG OPERATOR_USER="op"
ARG OPERATOR_UID="50000"

# Attach Labels to the image to help identify the image in the future
LABEL com.maxcotec.docker=true
LABEL com.maxcotec.docker.distro="debian"
LABEL com.maxcotec.docker.module="example-app-test-kpo"
LABEL com.maxcotec.docker.component="maxcotec-KubernetesPodOperator-test"
LABEL com.maxcotec.docker.uid="${OPERATOR_UID}"

# Add environment variables based on arguments
ENV OPERATOR_HOME ${OPERATOR_HOME}
ENV OPERATOR_USER ${OPERATOR_USER}
ENV OPERATOR_UID ${OPERATOR_UID}
ENV BUCKET_NAME ${BUCKET_NAME}
ENV S3_ENDPOINT ${S3_ENDPOINT}

# Add user for code to be run as (we don't want to be using root)
RUN useradd -ms /bin/bash -d ${OPERATOR_HOME} --uid ${OPERATOR_UID} ${OPERATOR_USER}

################
# Dist Image
################
FROM envs as dist

# run update
RUN set -ex && apt-get update

# Set our user to the operator user
USER ${OPERATOR_USER}
WORKDIR ${OPERATOR_HOME}
COPY main.py .

RUN printf '#!/usr/bin/env bash  \n\
exec python ${OPERATOR_HOME}/main.py "$@"\
' >> ${OPERATOR_HOME}/entrypoint.sh

RUN chmod 700 ${OPERATOR_HOME}/entrypoint.sh
ENTRYPOINT [ "/home/op/entrypoint.sh" ]