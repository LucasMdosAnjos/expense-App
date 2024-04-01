//
//  LoginViewModel.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class LoginViewModel: ObservableObject{
    // Campos do formulário
    @Published var email = ""
    @Published var password = ""
    
    // Validação de erros
    @Published var formIsValid = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
        validateForm()
    }
    
    private func validateForm() {
        // Validar formulário aqui
        Publishers.CombineLatest(
            $email,
            $password
        )
        .map { email, password in
            // Regras de validação básicas
            return !email.isEmpty && !password.isEmpty
        }
        .assign(to: \.formIsValid, on: self)
        .store(in: &cancellables)
    }
    
    func loginUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard formIsValid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Formulário inválido"])))
            return
        }
        
        authRepository.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    completion(.success(userModel))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getLastLoggedUser(){
        let result = authRepository.getLastLoggedUser()
        email = result.email
    }
}
