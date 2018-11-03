# cryptopath/offlineimap

[![Version][img-version]][badge] [![Layers][img-layers]][badge] [![Pulls][img-pulls]][hub] [![Stars][img-stars]][hub] [![Build Status][img-buildstatus]][buildstatus]

OfflineIMAP is a GPLv2 software to dispose your mailbox(es) as a local Maildir(s). For example, this allows reading the mails while offline without the need for your mail reader (MUA) to support disconnected operations. OfflineIMAP will synchronize both sides via IMAP. [OfflineIMAP](http://www.offlineimap.org/about/)

## Usage

```
docker create --name=offlineimap \
  -v <path to data volume>:/vol \
  -e CONFIG_PATH=<config - optional, default: /vol/config> \
  -e SECRETS_PATH=<secrets - optional, default: /vol/secrets> \
  -e MAIL_PATH=<mail - optional, default: /vol/mail> \
  -e CRON_SCHEDULE=<sync cron-job schedule - optional, default: "0 3 * * *"> \
  -e PUID=<uid - optional, default: 911> \
  -e PGID=<gid - optional, default: 911> \
  -e PGIDS=<additional gids - optional> \
  -e TZ=<timezone - optional> \
  cryptopath/offlineimap
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with `-p external:internal` - this shows the port mapping from internal (container) to external (host) ports.
So `-p 8080:80` would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.


* `-v /vol` - the base directory of the data volume
* `-e CONFIG_PATH` (default: `/vol/config`) - where offlineimap should store config files
* `-e SECRETS_PATH` (default: `/vol/secrets`) - folder for storing secrets (passwords, certificates)
* `-e MAIL_PATH` (default: `/vol/mail`) - local mail folder base path
* `-e CRON_SCHEDULE` (default: `"0 3 * * *"`) - the string supplied to cron for running the sync job
* `-e PUID` for UserID - see below for explanation
* `-e PGID` for GroupID - see below for explanation
* `-e PGIDS` for additional GroupIDs - see below for explanation
* `-e TZ` for timezone information, eg. Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it offlineimap /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`, as well as additional groups `PGIDS`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

You can also optionally specify additional group identifiers like this: `PGIDS="2001 2003 2004"`. These group-ids will then be added to the user.

## Example offlineimaprc

    [general]
    metadata = /vol/config/metadata
    accounts = user@example.org
    maxsyncaccounts = 3
    ui = basic
    socktimeout = 120

    [mbnames]
    enabled = yes
    filename = /vol/config/email/mailboxes
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
    localfolders = /vol/mail/user@example.org

    [Repository user@example.org-remote]
    type = IMAP
    remotehost = mail.example.org
    remoteuser = user@example.org
    remotepassfile = /vol/secrets/user@example.org.pass
    sslcacertfile: %(systemcacertfile)s
    ssl = yes
    readonly = True
    remoteport = 993

    [DEFAULT]
    systemcacertfile = /etc/ssl/certs/ca-certificates.crt

**Make sure the container is stopped before editing these settings.**

## Info

* To monitor the logs of the container in realtime `docker logs -f offlineimap`.

* container version number

`docker inspect -f '{{ index .Config.Labels "org.opencontainers.image.version" }}' offlineimap`

* image version number

`docker inspect -f '{{ index .Config.Labels org.opencontainers.image.version" }}' cryptopath/offlineimap`

## Author and license

(c) 2018 Ismail "CeRiAl" Khatib `<ikhatib@gmail.com>`.

This software is licensed under the MIT terms, you can find a copy of the
license on the `LICENSE` file in this repository.


## Versions

+ **2018-10-07:** Version 0.0.2.
+ **2018-10-06:** Initial Release.

[hub]: https://hub.docker.com/r/cryptopath/offlineimap/
[badge]: https://microbadger.com/images/cryptopath/offlineimap "Get your own badge on microbadger.com"
[buildstatus]: https://hub.docker.com/r/cryptopath/offlineimap/builds/
[img-version]: https://images.microbadger.com/badges/version/cryptopath/offlineimap.svg
[img-layers]: https://images.microbadger.com/badges/image/cryptopath/offlineimap.svg
[img-pulls]: https://img.shields.io/docker/pulls/cryptopath/offlineimap.svg
[img-stars]: https://img.shields.io/docker/stars/cryptopath/offlineimap.svg
[img-buildstatus]: https://img.shields.io/docker/build/cryptopath/offlineimap.svg
