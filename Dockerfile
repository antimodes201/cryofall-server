FROM ubuntu:18.04

MAINTAINER antimodes201

# quash warnings
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Set some Variables
ENV BRANCH "public"
ENV INSTANCE_NAME "default"
ENV GAME_PORT "6000"

# Being set as the DL is version dependent.  Petition to be set to latest
ENV GAME_VERSION "0.25.4.1"

# dependencies
RUN dpkg --add-architecture i386 && \
        apt-get update && \
        apt-get install -y --no-install-recommends \
		wget \
		unzip \
		ca-certificates 

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
		dpkg -i packages-microsoft-prod.deb && \
#		add-apt-repository universe && \
		apt-get update && \
		apt-get install -y --no-install-recommends apt-transport-https && \
		apt-get update && \
		apt-get install -y --no-install-recommends dotnet-sdk-3.0 \
		aspnetcore-runtime-3.1 && \
		rm -rf /var/lib/apt/lists/*

# add cfadmin user
RUN adduser \
    --disabled-login \
    --disabled-password \
    --shell /bin/bash \
    cfadmin && \
    usermod -G tty cfadmin \
        && mkdir -p /cryofall \
		&& mkdir -p /scripts \
        && chown cfadmin:cfadmin /cryofall \
		&& chown cfadmin:cfadmin /scripts 

# install server
USER cfadmin

# Deprecated install - moved into start script 
#RUN cd /cryofall && \
#	wget https://atomictorch.com/Files/CryoFall_Server_v${GAME_VERSION}_NetCore.zip && \
#	unzip CryoFall_Server_v${GAME_VERSION}_NetCore.zip && \
#	rm CryoFall_Server_v${GAME_VERSION}_NetCore.zip && \
#	mv CryoFall_Server_v${GAME_VERSION}_NetCore CryoFall_Server

ADD start.sh /scripts/start.sh

# Expose some port
EXPOSE ${GAME_PORT}/udp

# Make a volume
# contains configs and world saves
VOLUME /cryofall

CMD ["/scripts/start.sh"]
