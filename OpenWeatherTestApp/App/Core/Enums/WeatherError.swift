//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation

enum WeatherError: Error {
    case badDecode
    case locationDecline
}

extension WeatherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badDecode:
            return "Bad decoding"
        case .locationDecline:
            return "Please give me access to the location so that we can take the data and show you the weather in the current location"
        }
    }
}
