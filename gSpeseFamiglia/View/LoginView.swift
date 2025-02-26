//
//  LoginView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 18/02/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email, password
    }
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) {
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil // dismiss the keyboard
                    }
                    .onChange(of: password) {
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            })
            .padding(.horizontal)
            
            HStack {
                /*
                Button(action: {
                    register()
                }, label: {
                    Text("Sign Up")
                })
                .padding(.trailing)
                 */
                
                Button(action: {
                    login()
                }, label: {
                    Text("Log In")
                })
                //.padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .padding(.top)
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
            }
        }
        .onAppear(perform: {
            if Auth.auth().currentUser != nil { //user already logged
                print("User already logged")
                presentSheet = true
            }
        })
        .fullScreenCover(isPresented: $presentSheet) {
            ContentView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
 /*
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorMessage = "Registration Error: \(error.localizedDescription)"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
            } else {
                print("Registration Successfull")
                presentSheet = true
            }
        }
    }
  */
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorMessage = "Login Error: \(error.localizedDescription)"
                print(errorMessage)
                alertMessage = errorMessage
                showingAlert = true
            } else {
                print("Login Successfull")
                presentSheet = true
            }
        }
    }
}

#Preview {
    LoginView()
}
