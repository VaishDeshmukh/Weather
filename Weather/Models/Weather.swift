//
//  Weather.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation

struct WeatherEntity : Codable {

    var coord : MapCoordinate?
    var weather: [Weather]?
    var base: String?
    var main: Temperature?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int? // Time in UTC
    var sys: System?
    var timezone: Int? // Shift in seconds from UTC
    var id: Int?
    var name: String?
    var cod: Int?
}

struct MapCoordinate: Codable {
    var lon: Double?
    var lat: Double?
}

struct Weather: Codable {
    var id: Int?
    var main: String? //rain, snow, extreme
    var description: String?
    var icon: String?
}

struct Temperature: Codable {
    var temp: Double? // def Kelvin, metric: celsius, imperial: Farenheit
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double? //hPa
    var humidity: Double? // %
    var sea_level: Double?
    var grnd_level: Double?
}

struct Wind: Codable {
    var speed: Double? //def: meter/sec, metric: meter/sec, imperial: miles/hour
    var deg: Double? //degrees
    var gust: Double? //same as speed
}

struct Clouds: Codable {
    var all: Double? // cloudiness in %
}

struct System: Codable {
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Int? //time in UTC
    var sunset: Int? //time in UTC
}


extension WeatherEntity {

    static func fetch(data: [String: String], completion: @escaping (WeatherEntity?, Error?) -> Void) {


        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.setQueryItems(with: data)

        guard let urlString = components.url!.absoluteString.removingPercentEncoding else {return}
        guard let url = URL(string: urlString) else { return }

        let request = Resource.init(url: url)

        Network.shared.load(request) { response in
            switch response {
                case .success(let data):
                    do {
                        let items = try JSONDecoder().decode(WeatherEntity.self, from: data)
                        completion(items, composeError(domain: Constants.domainData, code: 0, message: Constants.errorJSONParsingDescription))
                    } catch {
                        completion(nil, composeError(domain: Constants.domainData, code: 1, message: Constants.errorJSONParsingDescription))
                    }
                case .failure(let error):
                    completion(nil, error)
            }
        }
    }
}
