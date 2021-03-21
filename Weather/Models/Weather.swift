//
//  Weather.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation
import UIKit

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

    func associatedCity() -> String {
        guard let name = name, let country = sys?.country else { return "" }
        return name + ", " + country
    }

    func getImageForWeatherDetail() -> UIImage? {

        var dayImage = UIImage()
        var nightImage = UIImage()

        let isDay = timezone?.associatedTimeZone().contains("AM") ?? false

        guard let cityWeather = weather?.first else { return nil}
        switch cityWeather.associatedCondition() {
            case .Thunderstorm:
                dayImage = UIImage(named: "thunderNight") ?? UIImage()
                nightImage = UIImage(named: "thunderDay") ?? UIImage()
            case .Drizzle:
                dayImage = UIImage(named: "drizzleDay") ?? UIImage()
                nightImage = UIImage(named: "drizzleDay") ?? UIImage()
            case .Rain:
                dayImage = UIImage(named: "rainDay") ?? UIImage()
                nightImage = UIImage(named: "rainNight") ?? UIImage()
            case .Snow:
                dayImage = UIImage(named: "snowDay") ?? UIImage()
                nightImage = UIImage(named: "snowNight") ?? UIImage()
            case .Clouds:
                dayImage = UIImage(named: "cloudsDay") ?? UIImage()
                nightImage = UIImage(named: "clouds") ?? UIImage()
            case .Atmosphere: fallthrough
            case .Clear:
                dayImage = UIImage(named: "clearDay") ?? UIImage()
                nightImage = UIImage(named: "clearNight") ?? UIImage()
        }

        return isDay ? dayImage : nightImage
    }
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

    func associatedImageUrl() -> String {
        var path = Constants.imageUrl
        if let id = icon {
            path.append(id)
            path.append("@2x.png")
        }
        return path
    }

    func dayOrNightImg() -> UIImage? {
        guard let icon = icon else {return UIImage()}

        if icon.contains("d") {
            return UIImage(named: "sunny")
        } else if icon.contains("n") {
            return UIImage(named: "night")
        }
        
        return nil
    }

    func associatedCondition() -> WeatherCode {
        guard let id = id else { return .Clear}
        return WeatherCode.getVal(val: id)
    }

    func associatedWaetherConditionImage() -> UIImage? {
        switch associatedCondition() {
            case .Thunderstorm: return UIImage(named: "thunderstorm")
            case .Drizzle: return UIImage(named: "drizzle")
            case .Rain: return UIImage(named: "rain")
            case .Snow: return UIImage(named: "snow")
            case .Atmosphere: return UIImage(named: "clear")
            case .Clear: return UIImage(named: "clear")
            case .Clouds: return UIImage(named: "clouds")
        }
    }

    enum WeatherCode  {
        case Thunderstorm
        case Drizzle
        case Rain
        case Snow
        case Atmosphere
        case Clear
        case Clouds

        static func getVal(val: Int) -> Self {

            switch val {
                case 200...299: return.Thunderstorm
                case 300...399: return.Drizzle
                case 500...599: return.Rain
                case 600...699: return.Snow
                case 700...799: return.Atmosphere
                case 800...800: return.Clear
                case 801...899: return.Clouds
                default: return .Clear
            }
        }
    }
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

    func getHumidity() -> String {
        guard let hum = humidity else {
            return "-"
        }
        return String(hum) + "%"
    }

    func getPressure() -> String {
        guard let press = pressure else {
            return "-"
        }
        return String(press) + "hPA"

    }
}

struct Wind: Codable {
    var speed: Double? //def: meter/sec, metric: meter/sec, imperial: miles/hour
    var deg: Double? //degrees
    var gust: Double? //same as speed

    func getWindSpeed() -> String {
        guard let wind = speed else {
            return "-"
        }
        return String(wind) + "m/sec"
    }
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
