// Use a cacheName for cache versioning
var cacheName = 'v1:static';

// During the installation phase, you'll usually want to cache static assets.
self.addEventListener('install', function(e) {
    // Once the service worker is installed, go ahead and fetch the resources to make this work offline.
    // these are the assets that will be cached
    e.waitUntil(
        caches.open(cacheName).then(function(cache) {
            return cache.addAll([
                './',
                'styles.css',
                'app.ico',
                'https://fonts.googleapis.com/css?family=Libre+Caslon+Display|Libre+Caslon+Text:400,400i,700&display=swap',
                'https://fonts.gstatic.com/s/librecaslondisplay/v1/TuGOUUFxWphYQ6YI6q9Xp61FQzxDRKmzr1lWfxk.woff2',
                'index.html',
                'https://picaq.github.io/sarasa/fonts/Sarasa-Mono-J-Regular.woff2',
                'time.js',
                'main.js',

            ]).then(function() {
                self.skipWaiting();
            });
        })
    );
});

// when the browser fetches a URL…
self.addEventListener('fetch', function(event) {
    // … either respond with the cached object or go ahead and fetch the actual URL
    event.respondWith(
        caches.match(event.request).then(function(response) {
            if (response) {
                // retrieve from cache
                return response;
            }
            // fetch as normal
            return fetch(event.request);
        })
    );
});


// window.addEventListener('beforeinstallprompt', (e) => {
//   // Stash the event so it can be triggered later.
//   deferredPrompt = e;
//   // Update UI notify the user they can add to home screen
//   showInstallPromotion();
// });

// btnAdd.addEventListener('click', (e) => {
//     // hide our user interface that shows our A2HS button
//     btnAdd.style.display = 'none';
//     // Show the prompt
//     deferredPrompt.prompt();
//     // Wait for the user to respond to the prompt
//     deferredPrompt.userChoice
//       .then((choiceResult) => {
//         if (choiceResult.outcome === 'accepted') {
//           console.log('User accepted the A2HS prompt');
//         } else {
//           console.log('User dismissed the A2HS prompt');
//         }
//         deferredPrompt = null;
//       });
//   });


