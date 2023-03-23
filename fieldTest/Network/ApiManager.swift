//
//  ApiManager.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation
import CoreData

public protocol Transport {
    func send(request: URLRequest) async throws -> Data
}

enum ApiError: Error {
    case interalServerError
    case notFound
    case other(String)
    
    init(statusCode: Int) {
        if statusCode == 500 {
            self = .interalServerError
        } else if statusCode == 404 {
            self = .notFound
        } else {
            let localizedString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            self = .other(localizedString)
        }
    }
}

public extension URLResponse {
    func validate() throws {
        if let httpResponse = self as? HTTPURLResponse {
            if !(200..<300).contains(httpResponse.statusCode) {
                throw ApiError(statusCode: httpResponse.statusCode)
            }
        }
    }
}

extension URLSession: Transport {
    public func send(request: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: request)
        try response.validate()
        return data
    }
}

public class ApiNetwork {
    let transport: Transport
    
    public init(transport: Transport = URLSession.shared) {
        self.transport = transport
    }
    
    public func send<T: Decodable>(request: URLRequest) async throws -> T {
        let data = try await transport.send(request: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func send(request: URLRequest) async throws {
        _ = try await transport.send(request: request)
    }
}

public struct HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let delete = "DELETE"
}

extension URLRequest {
    private static var baseUrL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    public static var fetchTodos: URLRequest {
        var request = URLRequest(url: baseUrL.appendingPathComponent("todos"))
        request.httpMethod = HTTPMethod.get
        return request
    }
    
    public static func createTodo(todo: TodoModel) -> URLRequest {
        var request = URLRequest(url: baseUrL.appendingPathComponent("todos"))
        let body = try? JSONEncoder().encode(todo)
        request.httpBody = body
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    public static func remove(id: Int) -> URLRequest {
        let todo = baseUrL.appendingPathComponent("todos").appendingPathComponent("\(id)")
        var request = URLRequest(url: todo)
        request.httpMethod = HTTPMethod.delete
        return request
    }
}
