//
//  Todo+CoreData.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 20. 3. 2023..
//

import Foundation
import CoreData

extension TodoModel: UUIDIdentifiable {
    init(managedObject: TodosEntity) {
        self.id = Int(managedObject.id)
        self.title = managedObject.title ?? ""
        self.completed = managedObject.completed
        self.userId = Int(managedObject.userId)
    }
    
    private func checkForExistingObjects(id: Int, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Bool {
        let fetchRequest = TodosEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        if let results = try? context.fetch(fetchRequest), results.first != nil {
            return true
        }
        return false
    }
    
    mutating func toManagedObject(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        guard let id = self.id else { return }
        guard checkForExistingObjects(id: id, context: context) == false else { return }
        let persistedValue = TodosEntity.init(context: context)
        
        persistedValue.id = Int64(id)
        persistedValue.title = self.title
        persistedValue.completed = self.completed
        persistedValue.userId = Int64(self.userId)
    }
}
