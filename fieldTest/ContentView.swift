//
//  ContentView.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: TodosViewModel
    @SectionedFetchRequest<Int64, TodosEntity>(
        sectionIdentifier: \TodosEntity.userId,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TodosEntity.userId,
                             ascending: true)
        ],
        predicate: NSPredicate(format: "isRemoved == %@", false),
        animation: .default
    ) private var items:
    SectionedFetchResults<Int64, TodosEntity>
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { todoItems in
                    Section(header: Text("Todos under identity number#\(todoItems.id)")) {
                        ForEach(todoItems) { todo in
                            NavigationLink(destination: EditTodo(todo: todo)) {
                                HStack {
                                    Text(todo.title ?? "")
                                    Spacer()
                                    Image(todo.completed ? "checkIcon" : "notDone")
                                        .frame(width: 12, height: 12)
                                        .onTapGesture {
                                            do {
                                                todo.completed = !todo.completed
                                                try viewContext.save()
                                            } catch let error{
                                                print(error)
                                            }
                                        }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                await deleteTodos(section: todoItems, offsets: indexSet)
                            }
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        Task {
                            await addItem()
                        }
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .task {
                await viewModel.fetchTodo()
            }
            Text("Select an item")
        } .overlay {
            if viewModel.isLoading {
                ProgressView("Fetching your todos...")
            }
        }
    }
    
    
    private func deleteTodos(section: SectionedFetchResults<Int64, TodosEntity>.Section, offsets: IndexSet) async {
        for index in offsets {
            await viewModel.deleteDodo(id:  Int(section[index].id))
        }
        offsets.map { section[$0] }.forEach(
            
            viewContext.delete
        )
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addItem() async{
        let random = Int.random(in: 200...2000)
        
        var newItem = TodoModel(userId:  0, id: random, title: "Todo#\(random)", completed: true)
        await viewModel.create(todo: newItem)
        
        newItem.toManagedObject(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: TodosViewModel(todoStore: TodoStoreService(
            context: PersistenceController.shared.container.viewContext
        ))).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
