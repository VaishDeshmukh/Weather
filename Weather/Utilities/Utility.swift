//
//  Utility.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct Resource {
    let url: URL
    let method: String = "GET"
}

enum APIDomainError: Error {
    case noData
}

extension URLRequest {

    init(_ resource: Resource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method
    }

}

extension URLComponents {
    mutating func setQueryItems(with params: [String: String]) {
        self.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value)}
    }
}

func composeError(domain: String, code: Int, message: String) -> NSError {
    return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey:message])
}
