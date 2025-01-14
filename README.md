<p align="center">
    A Safari App Extension that makes Reddit suck just a little bit less on Safari 13+.
</p>
<p align="center">
    <a href='https://apps.apple.com/us/app/tweaks-for-reddit/id1524828965?mt=12'>
        <img src='https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-mac-app-store.svg'>
    </a>
</p>

## Background

This project started in June 2019 as an attempt to port the entirety of the Reddit Enhancement Suite to the Safari App Extension framework. Since then, this project has diverted from that path and instead implements a select swath of features. Requests are welcome: simply open an issue. Pull requests are also welcome, as are code reviews.

## Requirements

As of version 1.4, redditweaks is only supported on macOS 10.15 (Catalina) and 11 (Big Sur). This is due to the adoption of SwiftUI and Combine in version 1.4.

Versions 1.3 and below were written in UIKit with the help of [SnapKit](https://github.com/SnapKit/SnapKit).

## Installation
1. Download the latest release from the [releases page](https://github.com/bermudalocket/redditweaks/releases).
2. Unzip the archive, and move `redditweaks.app` into `/Applications`.
3. Launch `redditweaks.app` and follow the prompt to enable the extension in Safari.
4. You may then close the app. It is not required to be open for the extension to work, but you cannot delete it.

## Development Note

The `./shared` folder contains (almost) all of the SwiftUI implementation for the extension's broswer toolbar popover. The Xcode canvas refuses to provide a preview for SwiftUI files whose sole target membership is a Safari Extension:

````
UnsupportedAppExtensionTypeError: redditweaks Extension.appex is unsupported

Previews cannot be hosted inside "com.apple.Safari.extension" app extensions
````

To get around this, I needed to add the  `redditweaks` target to the files' target memberships. This allows the Xcode canvas previews to work as intended.

## Historical Screenshots

    <img src='https://i.imgur.com/wytyfjh.jpg' width=85%>
    <img src='https://i.imgur.com/RLFPr6i.jpg' width=33%>
    <img src='https://i.imgur.com/VNxAfgB.jpg' width=33%>
    <img src='https://i.imgur.com/Mgz1lbk.png' width=33%>
