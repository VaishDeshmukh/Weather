//
//  Manager.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//
// This will be the main class which has access to all files which needs to be initialized only once & shared across the project. 

import Foundation
open class Manager {

    static var shared : Manager!
    var staticData : StaticData
    
    public init() {
        self.staticData = StaticData.init()
        Manager.shared = self
    }
}
