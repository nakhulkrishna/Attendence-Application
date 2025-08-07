//
//  appstates.swift
//  Attendence Application
//
//  Created by Nakhul Krishna on 07/08/25.
//

import FirebaseAuth

import Foundation
class AppViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false

    init() {
        self.isSignedIn = Auth.auth().currentUser != nil

        // Listen to state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.isSignedIn = user != nil
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.isSignedIn = false
    }
}
