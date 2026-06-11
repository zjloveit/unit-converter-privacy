import AppTrackingTransparency
import Foundation

enum AdConfig {
    static let adsEnabled = true

    #if DEBUG
    private static let appID = "ca-app-pub-3940256099942544~1458002511"
    private static let bannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    #else
    private static let appID = "ca-app-pub-4080585949658920~9888082003"
    private static let bannerUnitID = "ca-app-pub-4080585949658920/3694894501"
    #endif

    static var applicationID: String { appID }
    static var bannerID: String { bannerUnitID }

    static func requestTrackingAuthorizationIfNeeded() {
        guard adsEnabled else { return }
        guard #available(iOS 14, *) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
