//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation
import CoreLocation

class CityListViewModel: NSObject {
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private let networkProvider = NetworkProvider()
    private let citiesObserver = ManagedObjectContextObserver<CityEntety>(context: CoreDataProvider.current.persistentContainer.viewContext)
    private var handler: ((WeatherResponse?, Error?) -> Void)?
    
    var cityList: [CityEntety] = []
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherByCurrentLocation(handler: @escaping (WeatherResponse?, Error?) -> Void) {
        if locationManager.authorizationStatus == .denied {
            handler(nil, WeatherError.locationDecline)
        } else {
            self.handler = handler
            self.startUpdatingLocation()
        }
    }
    
    func getUpdateSubscribe(_ updateListHandler: @escaping () -> Void) {
        self.cityList = CoreDataProvider.current.getEntitiesListby() ?? []
        updateListHandler()
        citiesObserver.onContextChanged = { _ in
            self.cityList = CoreDataProvider.current.getEntitiesListby() ?? []
            updateListHandler()
        }
    }
}

extension CityListViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation()
        guard let currentLocation = locationManager.location else { return }
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            self.networkProvider.getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: { weatherReponse, error in
                self.handler?(weatherReponse, error)
            })
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            handler?(nil, WeatherError.locationDecline)
        default:
            break
        }
    }
}
