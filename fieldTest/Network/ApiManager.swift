//
//  ApiManager.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation

protocol APIManagerProtocol {
  func perform(_ request: RequestProtocol) async throws -> Data
}

class APIManager: APIManagerProtocol {
  private let urlSession: URLSession

  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }

  func perform(_ request: RequestProtocol) async throws -> Data {
    let (data, response) = try await urlSession.data(for: request.createURLRequest())
    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200 else { throw NetworkError.invalidServerResponse }
    return data
  }
}

protocol RequestProtocol {
  var path: String { get }
  var requestType: RequestType { get }
  var headers: [String: String] { get }
  var params: [String: Any] { get }
  var urlParams: [String: String?] { get }
  var addAuthorizationToken: Bool { get }
}

// MARK: - Default RequestProtocol
extension RequestProtocol {
  var host: String {
    return "jsonplaceholder.typicode.com"
  }

  var addAuthorizationToken: Bool {
    true
  }

  var params: [String: Any] {
    [:]
  }

  var urlParams: [String: String?] {
    [:]
  }

  var headers: [String: String] {
    [:]
  }

  func createURLRequest() throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    if !urlParams.isEmpty {
      components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
    }

    guard let url = components.url else { throw  NetworkError.invalidURL }

      var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestType.rawValue

    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }

    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if !params.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
    }

    return urlRequest
  }
}


public enum NetworkError: LocalizedError {
  case invalidServerResponse
  case invalidURL
  public var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "Invalid response."
    case .invalidURL:
      return "Invalid url."
    }
  }
}


enum RequestType: String {
  case GET
  case POST
  case DELETE
}



enum TodoRequest: RequestProtocol {
    case getTodos
    case deleteTodo(id: Int)

  var path: String {
    "/todos"
  }

//  var urlParams: [String: String?] 

  var requestType: RequestType {
    .GET
  }
}



