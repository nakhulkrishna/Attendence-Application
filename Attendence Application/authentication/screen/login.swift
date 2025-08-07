//
//  LoginView.swift
//  Attendance
//
//  Created by Nakhul Krishna on 06/08/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 24) {
            
            // App Icon
            Image(systemName: "bolt.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.bottom, 8)
                .foregroundColor(.blue)

            // Welcome Text
            Text("Welcome back!")
                .font(.title)
                .fontWeight(.bold)

            Text("Enter your credentials to jump back in.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Email Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.gray)

                TextField("example@mail.com", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }

            // Password Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            // Remember Me + Forgot Password
            HStack {
                Toggle(isOn: $rememberMe) {
                    Text("Remember me")
                        .font(.subheadline)
                }
                .toggleStyle(CheckboxToggleStyle())
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Forgot Password?") {
                    // Future implementation
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }

            // Sign In Button
            Button(action: {
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

                print("🔵 Attempting login for: \(trimmedEmail)")
                print("🔐 Email: '\(trimmedEmail)'")
                print("🔐 Password length: \(trimmedPassword.count)")

                AuthManager.shared.signIn(email: trimmedEmail, password: trimmedPassword) { result in
                    switch result {
                    case .success(let user):
                        print("✅ Login successful for: \(user.user.email ?? "unknown")")
                        // TODO: Navigate to next screen here

                    case .failure(let error):
                        print("❌ Login failed for \(trimmedEmail): \(error.localizedDescription)")
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
