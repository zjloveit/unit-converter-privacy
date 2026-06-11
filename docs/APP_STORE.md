# Unit Converter Explicit · App Store 上架清单

## 应用信息

| 项目 | 值 |
|------|-----|
| App 名称 | Unit Converter Explicit |
| Bundle ID | `com.dizhenyujing.unitconverter` |
| 版本 | 1.0.0 (1) |
| 类别 | Utilities |
| 主要语言 | English |
| 年龄分级 | 4+ |

## 必填 URL（已部署）

| 字段 | URL |
|------|-----|
| Privacy Policy | https://zjloveit.github.io/unit-converter-privacy/ |
| Support | https://zjloveit.github.io/unit-converter-privacy/support.html |
| Marketing URL（AdMob 用） | https://zjloveit.github.io/ |
| app-ads.txt | https://zjloveit.github.io/app-ads.txt |

## AdMob app-ads.txt（验证失败时必做）

AdMob 会从 App Store 的 **Marketing URL** 取域名，在**域名根路径**抓取 `app-ads.txt`（不是隐私政策子目录）。

| 项目 | 值 |
|------|-----|
| 文件内容 | `google.com, pub-4080585949658920, DIRECT, f08c47fec0942fa0` |
| 必须可访问 | https://zjloveit.github.io/app-ads.txt |
| Marketing URL | https://zjloveit.github.io/（与根域名一致） |
| Privacy Policy | 仍可填 https://zjloveit.github.io/unit-converter-privacy/（独立字段） |

### 部署步骤

1. 在 GitHub 新建空仓库：`zjloveit.github.io`（不要加 README）
2. **Settings → Pages** → Deploy from branch → `main` → **`/docs`**（与 unit-converter-privacy 相同，不要选 root）
3. 在本机执行：

```bash
cd ~/Projects/UnitConverter
chmod +x scripts/publish-developer-site.sh
./scripts/publish-developer-site.sh zjloveit
```

4. 浏览器打开 https://zjloveit.github.io/app-ads.txt 确认能看到一行 `google.com, pub-...`
5. **App Store Connect → App 信息 → Marketing URL** 改为 `https://zjloveit.github.io/`
6. AdMob → Apps → Unit Converter Explicit → **Check app-ads.txt**（或等待最多 24 小时自动重爬）

> 隐私政策在 `unit-converter-privacy` 子路径没问题；`app-ads.txt` 必须在 `zjloveit.github.io` 根路径，不能用 `.../unit-converter-privacy/app-ads.txt` 代替。

## 上架前必做（代码）

### 1. 创建 AdMob 应用（与地震 App 分开）

1. 打开 https://admob.google.com/
2. **Apps → Add app → iOS**
3. Bundle ID：`com.dizhenyujing.unitconverter`
4. 创建 **Banner** 广告单元
5. 将得到的 ID 填入：
   - `UnitConverter/Services/AdConfig.swift`（Release 分支）
   - `UnitConverter/Resources/Info.plist` → `GADApplicationIdentifier`

### 2. Xcode 签名

- Team：`V77HF8V7Z4`（已配置）
- **Automatically manage signing** 已开启

### 3. Archive 上传

```bash
cd ~/Projects/UnitConverter
open UnitConverter.xcodeproj
```

1. 顶部选 **Any iOS Device (arm64)**
2. **Product → Archive**
3. Organizer → **Distribute App** → App Store Connect → Upload

## App Store Connect 创建 App

1. https://appstoreconnect.apple.com/
2. **My Apps → + → New App**
3. Platform: iOS
4. Name: **Unit Converter Explicit**
5. Primary Language: **English (U.S.)**
6. Bundle ID: `com.dizhenyujing.unitconverter`
7. SKU: `unitconvert-001`

### 销售范围

建议勾选（除中国大陆外全球，或 Worldwide）：
- United States, United Kingdom, Canada, Australia, Japan, Germany, France 等

## 商店文案（复制粘贴）

### Subtitle（30 字符内）

```
Length, Weight & More
```

### Description

```
Unit Converter Explicit is a simple, free unit converter for everyday use.

Convert instantly on your device — no account required:
• Length (m, km, mi, ft, in…)
• Weight (kg, lb, oz…)
• Temperature (°C, °F, K) — including negative values
• Volume (L, gal, cup…)

FEATURES
• Works offline for calculations
• Clean, easy-to-use interface
• Swap units with one tap

DISCLAIMER
Results are for reference only. Always verify critical measurements independently.

This free app is supported by banner ads (Google AdMob).
```

### Keywords

```
converter,unit,length,weight,temperature,volume,metric,imperial,calculator,tools
```

### Review Notes（给审核员）

```
Unit Converter Explicit is a utility app for unit conversion.
All calculations run locally on device.
Ads: Google AdMob banner at bottom.
Privacy Policy: https://zjloveit.github.io/unit-converter-privacy/
No login, no user-generated content.
```

## App Privacy 问卷（必做，与二进制一致）

App 内含 `NSUserTrackingUsageDescription` 且会弹出 ATT 授权，**必须在 Connect 声明「会追踪用户」**，否则无法提交。

路径：**App Store Connect → 你的 App → App 隐私（App Privacy）→ 编辑**

### 第 1 步：是否收集数据

选 **「是，我们会从此 App 收集数据」**（Yes, we collect data from this app）

### 第 2 步：添加数据类型（与 `PrivacyInfo.xcprivacy` 一致）

添加 **Identifiers（标识符）→ Device ID（设备 ID）**：

| 问题 | 选择 |
|------|------|
| 用途 | **Third-Party Advertising**（第三方广告） |
| 是否与用户身份关联（Linked to User） | **否 / No** |
| 是否用于追踪（Used for Tracking） | **是 / Yes** |

以下类型 **不要添加**（本 App 不收集）：

- 联系信息、位置、健康、财务、浏览历史、用户内容等

> 可选：若 AdMob 后台要求更完整披露，可额外添加 **Usage Data → Product Interaction**，用途选 Third-Party Advertising，Tracking 选 Yes。当前 `PrivacyInfo.xcprivacy` 仅声明 Device ID，以上 Device ID 配置即可通过审核。

### 第 3 步：追踪（Tracking）

问：**「你或你的第三方合作伙伴是否会将数据用于追踪？」**

选 **「是」**（Yes）

追踪目的：**Third-Party Advertising**

### 第 4 步：发布

点 **发布**（Publish），等待产品页隐私标签更新后再提交审核。

### 与 App 内配置对应关系

| App 内 | Connect 填写 |
|--------|----------------|
| `NSUserTrackingUsageDescription` | 必须声明 Tracking = Yes |
| `PrivacyInfo.xcprivacy` → `NSPrivacyTracking = true` | 同上 |
| AdMob + ATT 弹窗 | Device ID + Third-Party Advertising |

### 若不想声明追踪（不推荐）

需从代码移除 ATT 请求并删除 `NSUserTrackingUsageDescription`，重新 Archive 上传。广告仍可展示，但个性化广告与 eCPM 会下降。**当前 AdMob 方案请按上文填写 Connect，无需改代码。**

## 截图尺寸

| 尺寸 | 模拟器 |
|------|--------|
| 6.7" | iPhone 15 Pro Max / 16 Pro Max |
| 6.5" | iPhone 11 Pro Max |
| 5.5" | iPhone 8 Plus（若需要） |

模拟器内 **⌘ + S** 截图，保存到桌面。

## 出口合规

- 使用 HTTPS only → **ITSAppUsesNonExemptEncryption = false** → 选「否」

## 协议与收款

App Store Connect → **Agreements, Tax, and Banking** 完成付款与税务信息。
