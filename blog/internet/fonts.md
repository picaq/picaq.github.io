---
title: Fonts
permalink: blog/internet/fonts
parent: Internet
nav_order: 3
---

# Fonts

## WOFF2

Compress OTF & TTF files to WOFF & WOFF2 if you desire to use custom fonts

I am using https://github.com/google/woff2

follow the instructions there to install.

install Brotli dependency submodules inside `/woff2` if not already there:

```sh
git submodule update --init
```

create an alias to run this script from anywhere not just in the `/woff2` git repository/directory

```sh
alias woff2_compress='~/<whatever_path>/woff2/woff2_compress'
````

compress your font files in the current directory

```sh
for file in *.ttf; do
  woff2_compress "$file"
done
```
