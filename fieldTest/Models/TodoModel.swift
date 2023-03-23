//
//  TodoModel.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation

public struct TodoModel: Codable {
    public var id: Int?
    public let userId: Int
    public let title: String
    public let completed: Bool

    public init(userId: Int, id: Int, title: String, completed: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.completed = completed
    }
}

extension TodoModel: Identifiable {
    
}
