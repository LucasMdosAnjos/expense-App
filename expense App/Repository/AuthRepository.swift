//
//  AuthRepository.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
import Firebase
import CoreData

protocol AuthRepositoryProtocol {
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func register(email: String, password: String, completion:  @escaping (Result<UserModel, Error>) -> Void)
    func logout()
    func refreshLastLoggedUser(email: String)
    func clearLastLoggedUser()
    func getLastLoggedUser() -> LastLoggedUserModel
}

class AuthRepository: AuthRepositoryProtocol {
    let auth = Auth.auth()
    let managedObjectContext = PersistenceController.shared.container.viewContext
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                let user = authResult.user
                // Mapeia o User do Firebase para UserModel
                let userModel = UserModel(uid: user.uid, email: user.email)
                let email = userModel.email
                // Salva localmente o email do ultimo usuario logado
                if let email = email{
                    self.refreshLastLoggedUser(email: email)
                }
                completion(.success(userModel))
            } else {
                completion(.failure(NSError(domain: "AuthDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erro desconhecido."])))
            }
        }
    }
    
    func register(email: String, password: String, completion:  @escaping (Result<UserModel, Error>) -> Void){
        auth.createUser(withEmail: email, password: password) {[self] authResult, error in
            if let error = error {
                completion(.failure(error))
                
            } else if let authResult = authResult {
                let user = authResult.user
                // Mapeia o User do Firebase para UserModel
                let userModel = UserModel(uid: user.uid, email: user.email)
                let email = userModel.email
                // Salva localmente o email do ultimo usuario logado
                if let email = email{
                    self.refreshLastLoggedUser(email: email)
                }
                completion(.success(userModel))
            }else{
                completion(.failure(NSError(domain: "AuthDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erro desconhecido."])))
            }
        }
    }
    
    func logout(){
        do{
            try auth.signOut()
        }catch{
            print("Error in signout firebase")
        }
    }
    
    func refreshLastLoggedUser(email: String){
        clearLastLoggedUser()
        let lastLoggedUser = LastLoggedUser(context: managedObjectContext)
        lastLoggedUser.email = email
        do {
            try managedObjectContext.save()
        } catch {
            // Tratar erro de acordo
            print("Error in saving last logged user: \(error.localizedDescription)")
        }
    }
    
    internal func clearLastLoggedUser(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LastLoggedUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let container = PersistenceController.shared.container
        
        do{
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        }catch let error as NSError {
            print("Error in clear LastLoggedUser objects: \(error), \(error.userInfo)")
        }
    }
    
    func getLastLoggedUser() -> LastLoggedUserModel{
        let fetchRequest: NSFetchRequest<LastLoggedUser> = LastLoggedUser.fetchRequest()
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.isEmpty{
                return LastLoggedUserModel(email: "")
            }else{
                let lastLoggedUser = results.first
                if let lastLoggedUser = lastLoggedUser{
                    return LastLoggedUserModel(email: lastLoggedUser.email ?? "")
                }
                return LastLoggedUserModel(email: "")
            }
            } catch {
                print("Erro ao buscar LastLoggedUser: \(error)")
                return LastLoggedUserModel(email: "")
        }
    }
    
}
