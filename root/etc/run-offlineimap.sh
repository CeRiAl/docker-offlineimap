#!/usr/bin/with-contenv bash

export HOME=/config
cd $HOME && exec s6-setuidgid abc /usr/bin/offlineimap -o -c /config/offlineimaprc
