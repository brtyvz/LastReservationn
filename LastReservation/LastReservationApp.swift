//
//  LastReservationApp.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import SwiftUI
import Firebase
import UIKit

@main
struct LastReservationApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    
            }
            .environmentObject(settingsViewModel)
            .accentColor(settingsViewModel.appThemeColor)
            .preferredColorScheme(settingsViewModel.theme)
            .environmentObject(viewModel)
        }
    }
}
