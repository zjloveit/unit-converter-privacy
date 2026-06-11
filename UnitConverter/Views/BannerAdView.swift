import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdContainer: View {
    private let bannerHeight: CGFloat = 50

    var body: some View {
        if AdConfig.adsEnabled {
            BannerAdView(adUnitID: AdConfig.bannerID)
                .frame(maxWidth: .infinity)
                .frame(height: bannerHeight)
                .background(Color(.secondarySystemBackground))
                .clipped()
                .accessibilityLabel("Advertisement")
        }
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.clipsToBounds = true
        load(banner)
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        if uiView.rootViewController == nil {
            load(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func load(_ banner: GADBannerView) {
        DispatchQueue.main.async {
            banner.rootViewController = Self.topViewController()
            guard banner.rootViewController != nil else { return }
            banner.load(GADRequest())
        }
    }

    private static func topViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let root = scene.windows.first(where: \.isKeyWindow)?.rootViewController
        else { return nil }

        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }

    final class Coordinator: NSObject, GADBannerViewDelegate {}
}
