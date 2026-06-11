import GoogleMobileAds
import SwiftUI

struct ContentView: View {
    @State private var selectedCategory: ConversionCategory = .length

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ConversionCategory.allCases) { category in
                        Text(category.segmentTitle).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ConverterView(category: selectedCategory)
                    .id(selectedCategory)
            }
            .navigationTitle("Unit Converter Explicit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .task {
            if AdConfig.adsEnabled {
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
            AdConfig.requestTrackingAuthorizationIfNeeded()
        }
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section("About") {
                Text("Unit Converter Explicit is a simple offline-friendly converter for length, weight, temperature, and volume.")
                Text("All calculations run on your device. No account required.")
            }

            Section("Disclaimer") {
                Text("Results are provided for reference only and are not guaranteed to be error-free. Always verify critical measurements independently.")
            }

            Section("Advertising") {
                Text("This free app is supported by Google AdMob banner ads.")
            }
        }
        .navigationTitle("About")
    }
}
