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
    let contecxt = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TodosViewModel(todoStore: TodoStoreService(
                context: contecxt
              )))
            .environment(
              \.managedObjectContext,
              contecxt
            )
        }
    }
}
