//
//  WeatherNetworkTests.swift
//  WeatherNetworkTests
//
//  Created by Vaishnavi Deshmukh on 21/3/21.
//

import XCTest
@testable import Weather

class WeatherNetworkTests: XCTestCase {

    var sut: URLSession!

    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // Asynchronous test: success fast, failure slow
    func testValidCallToOpenWeatherGetsHTTPStatusCode200() {
        // given
        let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=sydney&appid=b08e2d374f0345c0c9a13653f5124024&units=metric")
        // 1
        let promise = expectation(description: "Status code: 200")

        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
    }

    // Asynchronous test: faster fail
    func testCallToOpenWeatherCompletes() {
        // given
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=sydney&appid=b08e2d374f0345c0c9a13653f5124024&units=metric")
        // 1
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
