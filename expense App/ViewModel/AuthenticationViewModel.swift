//
//  AuthenticationViewModel.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    private var authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()){
        self.authRepository = authRepository
    }
    @Published var loggedUser: UserModel?

    func loginUser(with user: UserModel) {
        self.loggedUser = user
    }

    func logoutUser() {
        authRepository.logout()
        self.loggedUser = nil
    }
    
    var isLoggedIn: Bool {
        return loggedUser != nil
    }
}
