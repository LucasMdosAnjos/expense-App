//
//  RegisterViewModel.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
import Combine
import Firebase
class RegisterViewModel: ObservableObject {
    // Campos do formulário
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
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
        Publishers.CombineLatest3(
            $email,
            $password,
            $confirmPassword
        )
        .map { email, password, confirmPassword in
            // Regras de validação básicas
            return !email.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
        }
        .assign(to: \.formIsValid, on: self)
        .store(in: &cancellables)
    }
    
        func registerUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
            guard formIsValid else { return }
            
            authRepository.register(email: email, password: password) { result in
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
}
