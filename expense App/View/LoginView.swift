//
//  LoginView.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack{
            Spacer().frame(height: 50)
            Text("Login").fontWeight(.bold).font(.title)
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.vertical)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical)
            Spacer()
            Button(action: {
                DispatchQueue.main.async {
                    viewModel.loginUser{result in
                        switch result {
                        case .success(let userModel):
                            authViewModel.loginUser(with: userModel)
                        case .failure(let error):
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.showAlert = true
                        }
                    }
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.formIsValid ? Color.purple : Color.purple.opacity(0.3))
                    .cornerRadius(10)
                    .padding()
            }
            .disabled(!viewModel.formIsValid)
            Spacer().frame(height: 25)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
        .padding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        .onAppear{
            viewModel.getLastLoggedUser()
        }
        
    }
}

#Preview {
    LoginView()
}
