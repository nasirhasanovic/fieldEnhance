//
//  TodosViewModel.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation

protocol TodosFetcher {
  func fetchTodos() async -> [TodoModel]
}


@MainActor
final class TodosViewModel : ObservableObject {
    @Published var isLoading: Bool
    @Published var hasMoreAnimals = true
    private let todoFetcher: TodosFetcher
//    private let animalStore: AnimalStore
    
    init(
      isLoading: Bool = true,
      todoFetcher: TodosFetcher
    ) {
      self.isLoading = isLoading
      self.todoFetcher = todoFetcher

    }
    
    func fetchTodo() async {
        let todos = await todoFetcher.fetchTodos()
        
//        do {
            try await print(todos)
//        } catch {
//            print("Error storing animals... \(error.localizedDescription)")
//        }
    }

}


struct TodoService {
  private let requestManager: RequestManagerProtocol

  init(requestManager: RequestManagerProtocol) {
    self.requestManager = requestManager
  }
}

// MARK: - AnimalFetcher
extension TodoService: TodosFetcher {
  func fetchTodos() async -> [TodoModel] {
      let requestData = TodoRequest.getTodos
    do {
      let todos: [TodoModel] = try await
        requestManager.perform(requestData)
      return todos
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
}
