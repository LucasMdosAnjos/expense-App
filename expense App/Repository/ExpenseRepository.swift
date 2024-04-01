//
//  ExpenseRepository.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
//import CoreData
import FirebaseFirestore

class ExpenseRepository {
    let db = Firestore.firestore()
    
    func addExpense(title: String, description: String, userId: String){
        let newExpense: [String: Any] = [
            "id":UUID().uuidString,
            "title": title,
            "description": description,
            "createdById": userId,
            "timestamp": FieldValue.serverTimestamp()
        ]
        db.collection("expenses").addDocument(data: newExpense){ error in
            if let error = error{
                print("Erroe in add Expense: \(error.localizedDescription)")
            }else{
                print("Expense added with success")
            }
        }
    }
    
    func getExpenses(userId: String, completion: @escaping ([ExpenseModel]) -> Void) {
        db.collection("expenses")
            .whereField("createdById", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error searching Expenses: \(error.localizedDescription)")
                    completion([])
                } else {
                    let expenses = querySnapshot?.documents.compactMap { document -> ExpenseModel? in
                        let data = document.data()
                        guard let id = data["id"] as? String,
                              let title = data["title"] as? String,
                              let description = data["description"] as? String,
                              let createdById = data["createdById"] as? String else {
                                  return nil
                              }
                        return ExpenseModel(id: UUID(uuidString: id) ?? UUID(), title: title, description: description, createdById: createdById)
                    } ?? []
                    completion(expenses)
                }
            }
    }
    
    func deleteExpense(expense: ExpenseModel, completion: @escaping (Result<Any, Error>) -> Void){
        db.collection("expenses").whereField("id", isEqualTo: expense.id!.uuidString).getDocuments {[self] (querySnapshot, error) in
            if let error = error {
                   print("Error in searching documents: \(error.localizedDescription)")
                completion(.failure(error))
               } else if let querySnapshot = querySnapshot {
                   for document in querySnapshot.documents {
                       db.collection("expenses").document(document.documentID).delete()
                   }
                   completion(.success(""))
               }
        }
    }
}
