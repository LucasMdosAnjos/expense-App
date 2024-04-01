//
//  PersistenceController.swift
//  expense App
//
//  Created by Lucas Monteiro on 30/03/24.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExpenseApp") // Substitua "NomeDoSeuModelo" pelo nome do seu arquivo .xcdatamodeld
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Erro irreversível ao carregar o Persistent Store: \(error), \(error.userInfo)")
            }
        })
    }
}
