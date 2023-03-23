//
//  TodosViewModel.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation

protocol TodosStore {
    func save(todos: [TodoModel]) async throws
}

@MainActor
final class TodosViewModel : ObservableObject {
    @Published var isLoading: Bool
    @Published var hasMoreAnimals = true
    
    private let todosStore: TodosStore
    private var api = ApiNetwork()
    init(
        isLoading: Bool = true,
        todoStore: TodosStore
    ) {
        self.isLoading = isLoading
        self.todosStore = todoStore
    }
    
    func fetchTodo() async {
        isLoading = true
        do {
            let todos: [TodoModel] = try await api.send(request: .fetchTodos)
            do {
                try await todosStore.save(todos: todos)
            } catch {
                print("Error storing animals... \(error.localizedDescription)")
            }
            isLoading = false
        } catch let error {
            print(error)
            isLoading = false
        }
        
    }
    
    func create(todo: TodoModel) async {
        do {
            let todo: TodoModel = try await api.send(request: .createTodo(todo: todo))
            print(todo)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteDodo(id: Int) async {
        do {
            try await api.send(request: .remove(id: id))
        } catch let error {
            print(error.localizedDescription)
            
        }
    }
}
