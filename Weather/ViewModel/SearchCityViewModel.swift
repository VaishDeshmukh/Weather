//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import Foundation


class SearchCityViewModel {

    func fetchWeatherResponse(input: String) {

        var payload: [String: String] = [:]
        payload.updateValue( Constants.apiKey , forKey: Constants.appId)
        payload.updateValue("metric", forKey: "units")

        if input.isStringContainsOnlyNumbers() {
            payload.updateValue(input, forKey: "zip")
        } else if input.contains(",") {
//            let parts = input.components(separatedBy: ",")

        } else {
            payload.updateValue(input, forKey: "city")
        }


        print(payload)
    }
}

