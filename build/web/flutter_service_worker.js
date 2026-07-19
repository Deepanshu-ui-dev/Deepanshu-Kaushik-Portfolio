'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "5a82ce817488a0d8dab34b7c573fac74",
"index.html": "9da6fe0dc0f1a04306124f6b95e40c2d",
"/": "9da6fe0dc0f1a04306124f6b95e40c2d",
"main.dart.js": "4503939d9fc6957b982d12417e851f03",
"version.json": "bfc5cc78936fc3bff82415ff79f1e809",
"assets/assets/fonts/JetBrainsMono-Regular.ttf": "3c265c5a740649823327d74a46a84d54",
"assets/assets/fonts/JetBrainsMono-Bold.ttf": "79e9a0365a86aeb48c8d51212b215c9b",
"assets/assets/fonts/Inter-Medium.ttf": "a473e623af12065b4b9cb8db4068fb9c",
"assets/assets/fonts/Inter-Bold.ttf": "8f2869a84ad71f156a17bb66611ebe22",
"assets/assets/fonts/Inter-Regular.ttf": "fdb50e0d48cdcf775fa1ac0dc3c33bd4",
"assets/assets/fonts/Inter-SemiBold.ttf": "4d24f378e7f8656a5bccb128265a6c3d",
"assets/assets/fonts/Outfit-Regular.ttf": "7dd4b180f491085565755c3c4e145f3c",
"assets/assets/fonts/Outfit-Medium.ttf": "1abd213920cabff32b99143ed695336b",
"assets/assets/fonts/Outfit-SemiBold.ttf": "c73b093c0726199e1c0a691323594f47",
"assets/assets/fonts/Outfit-Bold.ttf": "a4df0b6a65f756775852ca6682abb9d6",
"assets/assets/fonts/Outfit-ExtraBold.ttf": "4fce5166680257bb6cdec560ed15c2a2",
"assets/assets/icons/linkedin.svg": "ff7f95a3132ac21bcf4b3b50745d1479",
"assets/assets/icons/x.svg": "fc21d298292541df9dced56ea819edbf",
"assets/assets/icons/github.svg": "c069f9ab40f78ff4b80b41852466f7d6",
"assets/assets/images/profile.png": "e62ffc45987f6070344b24eb20ba2bb7",
"assets/assets/images/oneko.gif": "4c5537784531d8ee7ef0316cf7c04c4d",
"assets/assets/images/gdg1.jpeg": "72008a550cfd0c9957e9168c0a7abe2f",
"assets/assets/images/cc1.jpeg": "53492c87021d2eca3af1302586ef1bfb",
"assets/packages/lucide_icons/assets/lucide.ttf": "03f254a55085ec6fe9a7ae1861fda9fd",
"assets/fonts/MaterialIcons-Regular.otf": "7d161b10e8491fa9762f6865f737f42d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "874b0649a38119120a653bc01f33e97f",
"assets/AssetManifest.bin.json": "fb5de13d2a16e6b5492aee595695b6b6",
"assets/FontManifest.json": "faf46285942a5b6090805f53db22030b",
"assets/NOTICES": "dc93e5c0c081038211cdc0408d33ca00",
"favicon.png": "a2804e6c3261491097c6571d7cade58b",
"manifest.json": "a5221c58d3327237c8b20e3e9e623b7d",
"icons/Icon-512.png": "46c917b0a42a147f3a532b01f20db5d0",
"icons/Icon-maskable-192.png": "870c93785cc826bde32be7924d632248",
"icons/Icon-maskable-512.png": "46c917b0a42a147f3a532b01f20db5d0",
"icons/Icon-192.png": "870c93785cc826bde32be7924d632248",
"preview.png": "8540730503b99d8e927fe063989fbbf4",
"robots.txt": "4e03e7d84e4817f399bdaa842fd3107a",
"sitemap.xml": "1771a5c54dc547d970b08ffd2ec0b1c1"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
