//
//  Network.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation


class Network {
    static let shared = Network()

    func load(_ resource: Resource, result: @escaping ((Result<Data>) -> Void)) {
        let request = URLRequest(resource)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let `data` = data else {
                result(.failure(APIDomainError.noData))
                return
            }
            if let `error` = error {
                result(.failure(error))
                return
            }
            result(.success(data))
        }
        task.resume()
    }
}

