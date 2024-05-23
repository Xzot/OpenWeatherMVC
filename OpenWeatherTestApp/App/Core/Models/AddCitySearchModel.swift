//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation

struct AddCitySearchModel {
    let city: String?
    let country: String?
    let lat, lon: Double?
    
    var name: String? {
        guard let city, let country else { return nil }
        return city + ", " + country
    }
}
