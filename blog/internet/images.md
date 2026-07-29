---
title: Images
permalink: blog/internet/images
parent: Internet
nav_order: 2
---

# Images

## Image Compression

Compress image size with minimal loss with webp format.

install webp to get access to cwebp.

```sh
apt install webp
```

In my experience, the `-lossless` & `-near_lossless` flags increased image sizes if converted from already compressed jpeg and png files.

```sh
cwebp -q 100 "imageName.jpg" -o "imageName.webp"
```

generally, I want the image to have the same name as before so I have this shell function

```sh
function compress { cwebp -q 100 "$@" -o "$@.webp" }
```
