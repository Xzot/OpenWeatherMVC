//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation
import MapKit

class AddCityViewModel {
    private let geocoder = CLGeocoder()
    private let networkProvider = NetworkProvider()
    var cities: [AddCitySearchModel] = []
    
    func updateList(city: String, didEndLoading: @escaping () -> Void) {
        getCoordinate(addressString: city) { [weak self] coordinate, place, error in
            self?.cities = [AddCitySearchModel(city: place?.locality, country: place?.country, lat: coordinate.latitude, lon: coordinate.longitude)]
            didEndLoading()
        }
    }
    
    func saveLocation(addCitySearchModel: AddCitySearchModel, handler: @escaping () -> Void) {
        guard let latitude = addCitySearchModel.lat, let longitude = addCitySearchModel.lon else { handler(); return }
        self.networkProvider.getWeather(latitude: latitude, longitude: longitude, completion: { weatherReponse, error in
            CityEntety.create(lat: latitude,
                              lon: longitude,
                              cityName: weatherReponse?.name,
                              countryName: addCitySearchModel.country,
                              iconString: weatherReponse?.weather.first?.icon,
                              temp: weatherReponse?.main.temp ?? 0.0,
                              weatherType: weatherReponse?.weather.first?.description)
            handler()
        })
    }
    
    private func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, CLPlacemark?, NSError?) -> Void ) {
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, placemark, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, nil, error as NSError?)
        }
    }
}
