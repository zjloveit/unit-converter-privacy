# Unit Converter Explicit

Free iOS unit converter for international App Store markets. English UI, AdMob banner ads.

## Features

- Length, weight, temperature, volume
- On-device calculation (no account)
- iPhone only, iOS 17+

## Setup

1. Open `UnitConverter.xcodeproj` (generate with `xcodegen generate` if missing)
2. Set your **Development Team** in Xcode Signing
3. Create an AdMob iOS app for `com.dizhenyujing.unitconverter`
4. Before **Release** upload, replace test IDs in:
   - `UnitConverter/Services/AdConfig.swift` (`#else` branch)
   - `UnitConverter/Resources/Info.plist` → `GADApplicationIdentifier`
5. Add a 1024×1024 app icon to `AppIcon.appiconset`
6. Deploy `docs/` to GitHub Pages (see below)

## GitHub Pages (privacy & support)

### 1. Create an empty repo on GitHub

1. Open https://github.com/new?name=unit-converter-privacy
2. Repository name: `unit-converter-privacy` (or your choice)
3. **Do not** check “Add a README”
4. Click **Create repository**

### 2. Push docs from your Mac

```bash
cd ~/Projects/UnitConverter
chmod +x scripts/publish-github-pages.sh
./scripts/publish-github-pages.sh 你的GitHub用户名 unit-converter-privacy
```

### 3. Enable Pages

1. https://github.com/你的GitHub用户名/unit-converter-privacy/settings/pages
2. **Build and deployment** → Source: **Deploy from a branch**
3. Branch: **main**, folder: **/docs** → Save

### 4. App Store Connect URLs

| Field | URL |
|-------|-----|
| Privacy Policy | `https://你的GitHub用户名.github.io/unit-converter-privacy/` |
| Support | `https://你的GitHub用户名.github.io/unit-converter-privacy/support.html` |
| Marketing URL (AdMob) | `https://你的GitHub用户名.github.io/` |
| app-ads.txt | `https://你的GitHub用户名.github.io/app-ads.txt` |

Deploy the developer root site (for AdMob `app-ads.txt`):

```bash
./scripts/publish-developer-site.sh 你的GitHub用户名
```

Create an empty repo named `你的GitHub用户名.github.io` first, then enable Pages from branch `main` / root.

## Build

```bash
cd ~/Projects/UnitConverter
xcodegen generate
open UnitConverter.xcodeproj
```

Debug builds use Google test ad units automatically.

## App Store

- **Name**: Unit Converter Explicit
- **Bundle ID**: `com.dizhenyujing.unitconverter`
- **Category**: Utilities
- **Privacy URL**: your GitHub Pages `docs/index.html`
