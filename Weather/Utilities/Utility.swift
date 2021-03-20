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

extension String {
    func isStringContainsOnlyNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

class StaticData {
    var cities : [CityList] = []
    
    init() {
        loadCountries()
    }

    fileprivate func loadCountries() {
        if let path = Bundle.main.path(forResource: "CityList", ofType: "json")  {
            let url = URL.init(fileURLWithPath: path)
            if let data = try? Data.init(contentsOf: url) {
                let decoder = JSONDecoder.init()
                if let cities = try? decoder.decode([CityList].self, from: data) {
                    self.cities = cities
                }
            }
        }
    }
}
