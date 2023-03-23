//
//  Todo Service.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 21. 3. 2023..
//

import Foundation
import CoreData

struct TodoStoreService {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }
}

// MARK: - AnimalStore
extension TodoStoreService: TodosStore {
  func save(todos: [TodoModel]) async throws {
    for var todo in todos {
     todo.toManagedObject(context: context)
    }
    try context.save()
  }
}

protocol UUIDIdentifiable: Identifiable {
  var id: Int? { get set }
    
}
