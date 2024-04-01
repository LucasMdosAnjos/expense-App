//
//  ExpenseModel.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
struct ExpenseModel: Identifiable{
    let id: UUID?
    let title: String
    let description: String
    let createdById: String
}
