//
//  AttendeceApp.swift
//  Attendece
//
//  Created by Nakhul Krishna on 05/08/25.
//

import SwiftUI
import Firebase

@main
struct AttendanceApp: App {
    @StateObject private var viewModel = AppViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isSignedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(viewModel) // 🔑 inject view model globally
            .preferredColorScheme(.light)
        }
    }
}
