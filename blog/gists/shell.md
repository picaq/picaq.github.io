---
title: Shell
permalink: blog/gists/sh
parent: Gists
nav_order: 6
---

# Shell Scripting

I primarily use ZSH

## Files

list filesize not in bytes
```sh
ls -lh filename
```

output looks like

```sh
-rw-r--r-- 1 picaq picaq 112M Feb  9 20:04 structured_data.ndjson
```

### Encryption

use GPG to encrypt with a passphrase

```sh
gpg -c filename.txt
```
will create `filename.txt.gpg`

to decrypt
```sh
gpg -d filename.txt.gpg
```
will cat the contents into the terminal
