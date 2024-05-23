//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation

protocol NetworkProviderProtocol {
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?, Error?) -> Void)
}

struct NetworkProvider: NetworkProviderProtocol {
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        let coordinates = "lat=\(latitude)&lon=\(longitude)"
        let fullUrl = "\(API.baseUrl)\(coordinates)&units=metric&appid=\(API.key)"
        guard let url = URL(string: fullUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil, error)
            }
            if let decoded = self.decodeJSON(type: WeatherResponse.self, from: data) {
                completion(decoded, nil)
            } else {
                completion(nil, WeatherError.badDecode)
            }
        }
        .resume()
    }
    
    
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from else { return nil }
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            return nil
        }
    }
}
