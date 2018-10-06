[appurl]: http://www.offlineimap.org/
[hub]: https://hub.docker.com/r/cryptopath/offlineimap/

# docker-offlineimap
[![](https://images.microbadger.com/badges/version/cryptopath/offlineimap.svg)](https://microbadger.com/images/cryptopath/offlineimap "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/cryptopath/offlineimap.svg)](https://microbadger.com/images/cryptopath/offlineimap "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/cryptopath/offlineimap.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/cryptopath/offlineimap.svg)][hub]

OfflineIMAP is a GPLv2 software to dispose your mailbox(es) as a local Maildir(s). For example, this allows reading the mails while offline without the need for your mail reader (MUA) to support disconnected operations. OfflineIMAP will synchronize both sides via IMAP. [OfflineIMAP](http://www.offlineimap.org/about/)

## Usage

```
docker create --name=offlineimap \
  -v <path to data>:/config \
  -v <path to mail>:/mail \
  -v <path to secrets folder>:/secrets \
  -e CRON_SCHEDULE=<sync job cron schedule> \
  -e PGID=<gid> -e PUID=<uid> \
  -e TZ=<timezone> \
  cryptopath/offlineimap
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-v /config` - where offlineimap should store config files
* `-v /mail` - local mail folder base path
* `-v /secrets` - folder for storing secrets (passwords, certificates)
* `-e CRON_SCHEDULE` sync job cron schedule - the string supplied to cron for running the sync job (default is "0 3 * * *")
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it offlineimap /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


## Example offlineimaprc

    [general]
    metadata = /config/metadata
    accounts = user@example.org
    maxsyncaccounts = 3
    ui = basic
    socktimeout = 120

    [mbnames]
    enabled = yes
    filename = /config/email/mailboxes
    header = "mailboxes "
    peritem = "+%(accountname)s/%(foldername)s"
    sep = " "
    footer = "\n"

    [Account user@example.org]
    localrepository = user@example.org-local
    remoterepository = user@example.org-remote
    autorefresh = 2
    quick=10

    [Repository user@example.org-local]
    type = Maildir
    localfolders = /mail/user@example.org

    [Repository user@example.org-remote]
    type = IMAP
    remotehost = mail.example.org
    remoteuser = user@example.org
    remotepassfile = /secrets/user@example.org.pass
    sslcacertfile: %(systemcacertfile)s
    ssl = yes
    readonly = True
    remoteport = 993

    [DEFAULT]
    systemcacertfile = /etc/ssl/certs/ca-certificates.crt

Stop the container before editing it or any changes won't be saved.


## Info

* To monitor the logs of the container in realtime `docker logs -f offlineimap`.

* container version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' offlineimap`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' cryptopath/offlineimap`


## Author and license

(c) 2018 Ismail "CeRiAl" Khatib `<ikhatib@gmail.com>`.

This software is licensed under the MIT terms, you can find a copy of the
license on the `LICENSE` file in this repository.


## Versions

+ **2018-10-06:** Initial Release.
