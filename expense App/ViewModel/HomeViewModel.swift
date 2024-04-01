//
//  HomeViewModel.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
class HomeViewModel: ObservableObject {
    var expenseRepository = ExpenseRepository()
    @Published var expenses: [ExpenseModel] = []
    
    func addExpense(title: String, description: String, userId: String) {
        expenseRepository.addExpense(title: title, description: description, userId: userId)
        self.fetchExpenses(userId: userId)
    }
    
    func fetchExpenses(userId: String) {
        //expenses = expenseRepository.getExpenses(userId: userId)
        expenseRepository.getExpenses(userId: userId){[self] result in
            expenses = result
        }
    }
    
    func deleteExpense(expense: ExpenseModel, userId: String){
        expenseRepository.deleteExpense(expense: expense){ [self] result in
            switch(result){
            case .success(_):
                fetchExpenses(userId: userId)
            case .failure(_):
                break
            }
        }
    }

}
