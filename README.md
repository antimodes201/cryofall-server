# cryofall-server
Docker Image for Cryofall Dedicated Server

Build to create a containerized version of Cryofall Dedicated Server
https://store.steampowered.com/app/829590/CryoFall/

Build by hand 

git clone https://github.com/antimodes201/cryofall-server.git 
docker build -t antimodes201/cryofall-server:latest .

Some notes.  Currently the server package is not handled through steamcmd (dont ask why, ask AtomicTorch).
Due to this the system has a scripted process that writes out the current version into a text file in your volume.
When an update comes out you will need to update the environment variable GAME_VERSION to the current version and restart the container.
This will trigger an update.  The old install is moved to a new directory with the old game version and the save data is copied over.
After a sucessful boot, you can delete the old copy of the save.

Docker Run with defaults 
change the volume options to a directory on your node and maybe use a different name then the one in the example

docker run -it -p 6000:6000/udp -v /app/docker/temp-vol:/cryofall \
	-e GAME_VERSION=0.23.8.10 \
	--name cryofall antimodes201/cryofall-server:latest


Currently exposed environmental variables and their defaul values 
GAME_VERSION 0.23.8.10 
GAME_PORT 6000 
