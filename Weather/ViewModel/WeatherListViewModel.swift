//
//  Presenter.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import Foundation

protocol WeatherListViewModelProtocol {
    func fetchListOfCities(input: [String])
}

protocol WeatherInfoListProtocol {
    func getList(input: [WeatherEntity])
}

class WeatherListViewModel : WeatherListViewModelProtocol {

    var listOfCities = [String]()
    var weatherList = [WeatherEntity]()

    var delegate: WeatherInfoListProtocol?

    func initialSetup() {

        // Get the weather for Sydney, Melbourne & Brisbane
        // Create a dictionary for the above cities with their city id's

        listOfCities.append(City.Sydney.associatedCityId())
        listOfCities.append(City.Melbourne.associatedCityId())
        listOfCities.append(City.Brisbane.associatedCityId())
        fetchListOfCities(input: listOfCities)

    }

    func fetchListOfCities(input: [String]) {
        var payload: [String: String] = [:]
        payload.updateValue( Constants.apiKey , forKey: Constants.appId)
        payload.updateValue("metric", forKey: "units")
        
        for (_, val) in input.enumerated() {

            payload.updateValue(val, forKey: "id")

            WeatherEntity.fetch(data: payload) { (data, error) in
                if let item = data {
                    DispatchQueue.main.async {
                        self.weatherList.append(item)
                        if self.weatherList.count >= 3 {
                            self.delegate?.getList(input: self.weatherList)
                        }
                    }
                } else if let err = error {
                    print(err)
                } else {
                    print(Constants.errorJSONParsingDescription)
                }
            }
        }
    }
}

