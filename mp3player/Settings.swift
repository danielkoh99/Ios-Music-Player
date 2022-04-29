//
//  Settings.swift
//  mp3player
//
//  Created by Dani on 28/03/2022.
//

import Foundation
import SwiftUI

struct Settings: View {
    @Binding var isDarkMode: Bool
    var body: some View {
        List {
            VStack {
                HStack {
                    Toggle("Theme", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { value in
                            UserDefaults.standard.set(value, forKey: "isDark")
                        }
                    Text(isDarkMode ? "Dark" : "Light")
                }
            }
        }.navigationTitle("Settings")
    }
}
