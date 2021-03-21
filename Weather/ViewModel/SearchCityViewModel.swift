//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import Foundation

protocol SearchCityViewDelegate {
    func getCity(city: WeatherEntity)
}

class SearchCityViewModel {

    var selectedCity: WeatherEntity?
    var delegate: SearchCityViewDelegate? = nil

    func fetchWeatherResponse(input: String) {

        var payload: [String: String] = [:]

        payload.updateValue( Constants.apiKey , forKey: Constants.appId)
        payload.updateValue("metric", forKey: "units")
        payload.updateValue(input, forKey: "id")

        WeatherEntity.fetch(data: payload) { (data, error) in
            if let item = data {
                DispatchQueue.main.async {
                    self.delegate?.getCity(city: item)
                }
            } else if let err = error {
                print(err)
            } else {
                print(Constants.errorJSONParsingDescription)
            }
        }
    }
}

