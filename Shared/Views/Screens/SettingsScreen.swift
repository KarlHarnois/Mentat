import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var envelopeRepo: EnvelopeRepository

    var body: some View {
        NavigationView {
            list
                .navigationTitle("Settings")
                .accessibilityIdentifier("\(SettingsScreen.self)")
                .navigationViewStyle(.stack)
        }
    }

    private var list: some View {
        List {
            Section {
            }

            Section(header: Text("Envelopes")) {
            }
        }
    }
}
