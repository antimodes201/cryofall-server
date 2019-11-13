#!/bin/bash
# Start script for Cryofall Dedicated Server Docker Image

verFile=/cryofall/version.txt
currentVer=`cat ${verFile}`
logFile=/cryofall/update.log
dateTime=`date +%m.%d.%Y:%H:%M`

# Check if container environment is newer then committed
if [ ! -f "${verFile}" ]
then
	# New Install
	printf "${dateTime},No Install Found\n" >> ${logFile}
	
	cd /cryofall && \
	wget https://atomictorch.com/Files/CryoFall_Server_v${GAME_VERSION}_NetCore.zip && \
	unzip CryoFall_Server_v${GAME_VERSION}_NetCore.zip
	rm CryoFall_Server_v${GAME_VERSION}_NetCore.zip
	mv CryoFall_Server_v${GAME_VERSION}_NetCore CryoFall_Server
	printf "${GAME_VERSION}\n" > ${verFile}
elif [ "${GAME_VERSION}" != "${currentVer}" ]
then
	# Need to update
	printf "${dateTime},Need to update ${currentVer} -> ${GAME_VERSION}\n" >> ${logFile}
	
	cd /cryofall && \
	mv CryoFall_Server CryoFall_Server_${currentVer}
	wget https://atomictorch.com/Files/CryoFall_Server_v${GAME_VERSION}_NetCore.zip
	unzip CryoFall_Server_v${GAME_VERSION}_NetCore.zip
	rm CryoFall_Server_v${GAME_VERSION}_NetCore.zip
	mv CryoFall_Server_v${GAME_VERSION}_NetCore CryoFall_Server
	cp -f /cryofall/CryoFall_Server_${currentVer}/Data /cryofall/CryoFall_Server/Data

	printf "${GAME_VERSION}\n" > ${verFile}
else
	# Current Version
	printf "${dateTime},Up to date\n" >> ${logFile}
fi

# LAUNCH THE GAME!
dotnet /cryofall/CryoFall_Server/Binaries/Server/CryoFall_Server.dll loadOrNew
