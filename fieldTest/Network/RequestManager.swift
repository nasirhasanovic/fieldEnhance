//
//  RequestManager.swift
//  fieldTest
//
//  Created by Nasir Hasanovic on 19. 3. 2023..
//

import Foundation

protocol RequestManagerProtocol {
  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

final class RequestManager: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol

  init(
    apiManager: APIManagerProtocol = APIManager(),
    parser: DataParserProtocol = DataParser()
  ) {
    self.apiManager = apiManager
    self.parser = parser
  }

  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
    let data = try await apiManager.perform(request)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
}


protocol DataParserProtocol {
  func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
  private var jsonDecoder: JSONDecoder

  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func parse<T: Decodable>(data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}
