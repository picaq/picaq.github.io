---
title: WSL
permalink: blog/gists/sh/wsl
parent: Shell
nav_order: 6
---

# Shell Scripting

I primarily use ZSH

## WSL

### downloads

remove :Zone.Identifier and .crdownload:com.dropbox.attrs from files downloaded into Ubuntu partition
```sh
rm *:Zone.Identifier *crdownload:com.dropbox.attrs
```

remove all zone.identifier from downloads to linux in dir
```sh
find . -type f -name "*:Zone.Identifier" -delete
```

### get wifi password
```sh
netsh.exe wlan show profile name="<Wifi Name>" key=clear | grep "Key Content"
```

## Unix

### password protect txt file with vim
```sh
vim -x <new or existing filename>
```
