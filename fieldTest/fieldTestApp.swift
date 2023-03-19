//
//  fieldTestApp.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import SwiftUI

@main
struct fieldTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TodosViewModel(todoFetcher: TodoService(requestManager: RequestManager())))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
