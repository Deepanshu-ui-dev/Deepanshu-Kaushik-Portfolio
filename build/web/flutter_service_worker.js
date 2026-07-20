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
"flutter_bootstrap.js": "64b27e7172dc4435395d1c9d94c67e3e",
"index.html": "9da6fe0dc0f1a04306124f6b95e40c2d",
"/": "9da6fe0dc0f1a04306124f6b95e40c2d",
"main.dart.js": "dd632ec4f26dcd41e13b0f2dc8f6cd2c",
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
"assets/assets/icons/github.svg": "61513c9df7c25dc322782144e1d9f058",
"assets/assets/icons/linkedin.svg": "398257be76eb7739f26ba45ea5c3fb6c",
"assets/assets/icons/x.svg": "a30289004f6fc16beac11875a856ace6",
"assets/assets/icons/gmail.svg": "e060ef587631a67bbf7ea92d8db53b09",
"assets/assets/images/profile.jpeg": "d2589124181b1a9d0d04b1b3a0f79a9e",
"assets/assets/images/cat.jpeg": "72ddd77cb0bc704b72d823e947c0c170",
"assets/assets/images/mount.jpeg": "66ed04fabb7a0cb5248ce9a220b482f8",
"assets/assets/images/flow.jpeg": "4ccb2432125552df976d14bebc2f2d98",
"assets/assets/images/sq.jpeg": "ffa4be8eccfed3192e4ae858b54c0aef",
"assets/assets/images/cross.png": "fbe63e1be4bab8efc3703ca9bdb129c4",
"assets/assets/images/cc2.jpeg": "ff16aadc8476891ec751a55e03d54c97",
"assets/assets/images/cc3.jpeg": "3180c1e74983c9919b210eb5d74deb65",
"assets/assets/images/cc1.jpeg": "53492c87021d2eca3af1302586ef1bfb",
"assets/assets/images/abessss.jpg": "af8b0e39714ea0afcb777efb32b5c5a3",
"assets/assets/images/sunshine.jpg": "ed7009b054db3fb148fa39f2d9f6d472",
"assets/assets/images/flower.jpg": "9386f79c8eded59381c3eb33331a1d10",
"assets/assets/images/fire.jpg": "d6d1db21654a19d22597b05b4feeb8ab",
"assets/assets/images/profile.png": "e62ffc45987f6070344b24eb20ba2bb7",
"assets/assets/images/oneko.gif": "4c5537784531d8ee7ef0316cf7c04c4d",
"assets/assets/images/shiv.jpeg": "3ed65767083cc5d0b0e9ff5a8cb42272",
"assets/assets/images/aabes.jpeg": "8f1e83292e00ce87248fc620c0ef79a7",
"assets/assets/images/abesss.jpeg": "15e978b4ac253689355b3b571b901768",
"assets/assets/images/caat.jpeg": "d89686a55c548e79e8a47d15db5ee3ff",
"assets/assets/images/flower.jpeg": "d19d6f944da46de3baca5dbbb5681390",
"assets/assets/images/cafe.jpeg": "7c5e7a8cb1f34ee95b9e4a4029e53107",
"assets/assets/images/gdg1.jpeg": "72008a550cfd0c9957e9168c0a7abe2f",
"assets/assets/images/gdg2.jpeg": "436cd3f3267535938743797424ba90f3",
"assets/assets/images/gdg3.jpeg": "431685d5dca4b2a91e442edb15de6d66",
"assets/packages/lucide_icons/assets/lucide.ttf": "03f254a55085ec6fe9a7ae1861fda9fd",
"assets/fonts/MaterialIcons-Regular.otf": "05a0f36706b33a91caadd25e92a2fa18",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "c171bf52c00da78776d063a715c5c4de",
"assets/AssetManifest.bin.json": "4db51286301b348d071efd03dc98564a",
"assets/FontManifest.json": "faf46285942a5b6090805f53db22030b",
"assets/NOTICES": "1c7ffadc30edbcf25a489dac2c2a9983",
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
