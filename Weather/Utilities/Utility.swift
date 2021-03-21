//
//  Utility.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation
import UIKit

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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Double {
    func associatedTemp() -> String {
        let idx = Int(self)
        return String(idx) + String("\u{00B0}") + "C"
    }
}

extension Int {
    func associatedTimeZone() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: self)

        return formatter.string(from: Date())
    }
}

func sunTimeCoverter(unixTimeValue: Double, timezone: String) -> String {
  let dateAndTime = NSDate(timeIntervalSince1970: unixTimeValue)
  let dateFormater = DateFormatter()
  dateFormater.dateStyle = .none
  dateFormater.timeStyle = .short
  dateFormater.timeZone = TimeZone(abbreviation: timezone)
  dateFormater.locale = Locale.autoupdatingCurrent
  let currentdateAndTime = dateFormater.string(from: dateAndTime as Date)
  return currentdateAndTime
}
