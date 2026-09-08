# Play in mpv — Brave + Edge

Play web pages, links, and media directly in mpv from Brave or Microsoft Edge using Chromium Native Messaging.

The v2.3 fixed package is available under **Releases/Downloads** as `Play-in-mpv-v2.3-Brave-Edge-FIXED.zip` when uploaded.

## Features

- Toolbar action to play the current page in mpv
- Context-menu actions for links, pages, and media
- Brave + Microsoft Edge support
- Purple mpv-style extension icon
- Optional yt-dlp integration for supported video sites
- Native host installer registers the host for both browsers
- Installer deduplicates identical extension IDs

## Installation

1. Extract the ZIP to a permanent folder.
2. Load the `extension` folder as an unpacked extension in Brave and Edge.
3. Copy each browser's extension ID.
4. Run `native-host\\install.bat` and enter the Brave and Edge IDs.
5. Fully close and reopen both browsers.

If Brave reports `Access to the specified native messaging host is forbidden`, remove the unpacked extension from `brave://extensions`, fully close Brave, reopen it, load the extension again, and verify that its runtime ID matches the ID entered into `install.bat`.
