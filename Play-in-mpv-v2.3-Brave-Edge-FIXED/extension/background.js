const HOST = "com.pavan.mpv";

function playInMpv(url) {
  if (!url) return;
  chrome.runtime.sendNativeMessage(HOST, { url }, (response) => {
    if (chrome.runtime.lastError) {
      console.error("mpv native host error:", chrome.runtime.lastError.message);
      return;
    }
    console.log("mpv response:", response);
  });
}

chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.removeAll(() => {
    chrome.contextMenus.create({
      id: "play-link",
      title: "Play link in mpv",
      contexts: ["link"]
    });
    chrome.contextMenus.create({
      id: "play-page",
      title: "Play page in mpv",
      contexts: ["page"]
    });
    chrome.contextMenus.create({
      id: "play-media",
      title: "Play media in mpv",
      contexts: ["audio", "video", "image"]
    });
  });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "play-link") playInMpv(info.linkUrl);
  else if (info.menuItemId === "play-media") playInMpv(info.srcUrl);
  else if (info.menuItemId === "play-page") playInMpv(tab?.url);
});

chrome.action.onClicked.addListener((tab) => playInMpv(tab?.url));