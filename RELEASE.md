# Release 构建

## 上传前检查

- [ ] AdMob 已创建 iOS 应用（Bundle: `com.dizhenyujing.unitconverter`）
- [ ] `AdConfig.swift` Release ID 与 `Info.plist` `GADApplicationIdentifier` 一致
- [ ] App Icon 1024×1024 已设置
- [ ] `CFBundleVersion` 已递增（每次上传 +1）
- [ ] 隐私政策 URL 可访问

## Archive

1. Xcode → **Any iOS Device (arm64)**
2. **Product → Archive**
3. **Distribute App** → App Store Connect → Upload

## 当前版本

- Marketing: 1.0.0
- Build: 1

详细上架步骤见 `docs/APP_STORE.md`。
