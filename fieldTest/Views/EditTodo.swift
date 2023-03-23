//
//  EditTodo.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 23. 3. 2023..
//

import SwiftUI
import CoreData

struct EditTodo: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var newTitle = ""
    var todo: TodosEntity
    var body: some View {
        
        VStack{
            TextField(todo.title ?? "", text: $newTitle)
                .padding(20)
            Spacer()
            Button(action: {
                saveChanges()
            }) {
                Text("Save")
                    .foregroundColor(Color.white)
            }
            .frame(width: 200, height: 50)
            .background(Color.green)
            .cornerRadius(5)
        }.toolbar {
            ToolbarItem {
                Button(action: {
                    Task {
                        changeStatus()
                    }
                }) {
                    Label("Add Item", image: todo.completed ? "checkIcon" : "notDone")
                }
            }
        }
    }
    
    func saveChanges() {
        if !newTitle.isEmpty {
            todo.title = newTitle
        }
        saveContext()
    }
    
    func changeStatus() {
        todo.completed = !todo.completed
        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            dismiss()
        } catch let error{
            print(error)
        }
    }
}

struct EditTodo_Previews: PreviewProvider {
    static var previews: some View {
        EditTodo(todo: TodosEntity(context: PersistenceController.shared.container.viewContext))
    }
}
