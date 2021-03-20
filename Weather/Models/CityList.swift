//
//  CityList.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import Foundation

struct CityList: Codable {

    let id: Int?
    let name: String?
    let state: String?
    let country: String?
    let coord: MapCoordinate?
}

struct LocationData: Codable {
    let name: String?
    let country: String?
    let id: Int?

    init(_ from : CityList) {
        self.name = from.name
        self.country = from.country
        self.id = from.id
    }
}
