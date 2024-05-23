//
//  AppDelegate.swift
//  OpenWeatherTestApp
//
//  Created by Vlad Shchuka on 23.05.2024.
//

import UIKit
import CoreData

enum API {
    static let key = "29e6ba8318f06812ef1160af089972e7"
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { return true }
}

