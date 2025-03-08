const CACHE_NAME = "pwa-cache-v1";
const STATIC_ASSETS = [
  "/",
  "index.html",
  "index.html",
  "sarasa.css",
  "sarasa-fonts.css",
  "prism.css",
  "prism-live.css",
  "sarasa.js",
  "prism.js",
  "prism-live.js",
  "favicon.ico",
  "android-chrome-192x192.png",
  "android-chrome-256x256.png",
  "fonts",
  "service-worker.js",
  "fonts/Sarasa-Mono-J-Light-Italic.woff2",
  "fonts/Sarasa-Mono-J-Bold.woff2",
  "fonts/Sarasa-UI-SC-Light.woff2",
  "fonts/Sarasa-Mono-J-Regular.woff2",
  "fonts/Sarasa-Mono-J-Italic.woff2",
  "apple-touch-icon.png",
  "favicon-32x32.png",
  "android-chrome-192x192.png",
  "favicon-16x16.png",
  "site.webmanifest",
  "safari-pinned-tab.svg",
  "favicon.ico",
  "sarasa.css",
  "sarasa-fonts.css",
  "prism.css",
  "prism-live.css",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    })
  );
});

self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});
