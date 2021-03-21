//
//  WeatherEntityTests.swift
//  WeatherEntityTests
//
//  Created by Vaishnavi Deshmukh on 21/3/21.
//

import XCTest
@testable import Weather

class WeatherEntityTests: XCTestCase {
    override class func setUp() {
        super.setUp()
    }

    func testParseCities() {
        let decoder = JSONDecoder.init()
        do {
            let data = citiesArray.data(using: String.Encoding.utf8)!
            _ = try decoder.decode([CityList].self, from: data)

            XCTAssert(true)

        } catch {
            XCTFail("Could not decode City List from object")
        }
    }

    func testParseWeatherData() {
        let decoder = JSONDecoder.init()
        do {
            let data = weatherData.data(using: String.Encoding.utf8)!
            _ = try decoder.decode(WeatherEntity.self, from: data)

            XCTAssert(true)

        } catch {
            XCTFail("Could not decode weather response from object")
        }
    }

}

let citiesArray =
    """
[
    {
        "id": 833,
        "name": "Ḩeşār-e Sefīd",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 47.159401,
            "lat": 34.330502
        }
    },
    {
        "id": 2960,
        "name": "‘Ayn Ḩalāqīm",
        "state": "",
        "country": "SY",
        "coord": {
            "lon": 36.321911,
            "lat": 34.940079
        }
    },
    {
        "id": 3245,
        "name": "Taglag",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 44.98333,
            "lat": 38.450001
        }
    },
    {
        "id": 3530,
        "name": "Qabāghlū",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 46.168499,
            "lat": 36.173302
        }
    },
    {
        "id": 5174,
        "name": "‘Arīqah",
        "state": "",
        "country": "SY",
        "coord": {
            "lon": 36.48336,
            "lat": 32.889809
        }
    },
    {
        "id": 7264,
        "name": "Kalāteh-ye Dowlat",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 57.616982,
            "lat": 36.163841
        }
    },
    {
        "id": 8084,
        "name": "Behjatābād",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 51.461639,
            "lat": 36.667431
        }
    },
    {
        "id": 9874,
        "name": "Ţālesh Maḩalleh",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 50.679192,
            "lat": 36.894329
        }
    },
    {
        "id": 11263,
        "name": "Shahrīār Kandeh",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 53.19902,
            "lat": 36.631939
        }
    },
    {
        "id": 11754,
        "name": "Bālā Aḩmad Kolā",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 52.667271,
            "lat": 36.649059
        }
    },
    {
        "id": 12795,
        "name": "Aş Şūrah aş Şaghīrah",
        "state": "",
        "country": "SY",
        "coord": {
            "lon": 36.573872,
            "lat": 33.032669
        }
    }
]
"""
let weatherData =
"""
{
    "coord": {
        "lon": -122.08,
        "lat": 37.39
    },
    "weather": [
        {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 282.55,
        "feels_like": 281.86,
        "temp_min": 280.37,
        "temp_max": 284.26,
        "pressure": 1023,
        "humidity": 100
    },
    "visibility": 16093,
    "wind": {
        "speed": 1.5,
        "deg": 350
    },
    "clouds": {
        "all": 1
    },
    "dt": 1560350645,
    "sys": {
        "type": 1,
        "id": 5122,
        "message": 0.0139,
        "country": "US",
        "sunrise": 1560343627,
        "sunset": 1560396563
    },
    "timezone": -25200,
    "id": 420006353,
    "name": "Mountain View",
    "cod": 200
}
"""



