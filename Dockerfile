FROM debian:jessie

RUN set -x; \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils wget vim htop lib32stdc++6 libcurl4-gnutls-dev:i386 && \
    apt-get clean && \
    apt-get autoclean

RUN set -x; \
    useradd -m steam

USER steam
ENV HOME /home/steam

RUN set -x; \
    mkdir -p $HOME/steamcmd $HOME/steamapps $HOME/.klei/DoNotStarveTogether && \
    cd $HOME/steamcmd && \
    wget "http://media.steampowered.com/installer/steamcmd_linux.tar.gz" && \
    tar -zxf steamcmd_linux.tar.gz && \
    ./steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +login anonymous \
        +force_install_dir $HOME/steamapps/DST \
        +app_update 343050 validate \
        +quit && \
    rm -f steamcmd_linux.tar.gz

ADD settings.ini modoverrides.lua worldgenoverride.lua $HOME/.klei/DoNotStarveTogether/
ADD dedicated_server_mods_setup.lua $HOME/steamapps/DST/mods/
ADD configure.sh change.slot.sh change.port.sh update.sh set.mods.sh override.world.sh $HOME/steamapps/DST/bin/

VOLUME ["$HOME/.klei/DoNotStarveTogether/"]
EXPOSE 10999/udp
WORKDIR $HOME/home/steam/DST/bin/
ENTRYPOINT ./dontstarve_dedicated_server_nullrenderer
