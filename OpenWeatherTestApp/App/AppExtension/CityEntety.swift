//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation
import CoreData

extension CityEntety {
    class func create(id: String = UUID().uuidString, lat: Double, lon: Double, cityName: String?, countryName: String?, iconString: String?, temp: Double, weatherType: String?) {
        let context = CoreDataProvider.current.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Self.description(), in: context) else { return }
        let newOrder = NSManagedObject(entity: entity, insertInto: context)
        guard let item = newOrder as? CityEntety else { return }
        item.cityIdentifier = id
        item.dateStore = Date()
        item.lat = lat
        item.lon = lon
        item.cityName = cityName
        item.countryName = countryName
        item.iconString = iconString
        item.temp = temp
        item.weatherType = weatherType
        CoreDataProvider.current.saveContext()
    }
}
