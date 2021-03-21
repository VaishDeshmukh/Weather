//
//  Constants.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation

struct Constants {
    static let scheme = "https"
    static let apiKey = "b08e2d374f0345c0c9a13653f5124024"
    static let appId = "appid"
    static let baseURL = "api.openweathermap.org/data/2.5/weather"
    static let errorJSONParsingDescription = "Failed to parse JSON while conversion"
    static let domainData = "Data"
    static let imageUrl = "http://openweathermap.org/img/wn/"
}


enum City : String {
    case Sydney
    case Melbourne
    case Brisbane

    func associatedCityId() -> String {
        switch self {
            case .Sydney: return "2147714"
            case .Melbourne: return "4163971"
            case .Brisbane: return "2174003"
        }
    }
}
