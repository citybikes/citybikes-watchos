//
//  StationModel.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

struct Station: Identifiable {
    init(json: JSON) {
        self.stationId = json["id"].string!
        self.emptySlots = json["empty_slots"].int!
        self.freeBikes = json["free_bikes"].int!
        self.latitude = json["latitude"].double!
        self.longitude = json["longitude"].double!
        self.distance = json["distance"].int!
        self.networkId = json["network_id"].string
        // Extra
        if json["extra"].exists() {
            self.address = json["extra"]["address"].string
            self.status = json["extra"]["status"].string
        }
        
        // Round the distance to tens of meters
        self.distance = Int(round(Float(self.distance) / 10) * 10)
    }
    
    init(stationId: String, address: String?, emptySlots: Int, freeBikes: Int, latitude: Double, longitude: Double, distance: Int, status: String?, networkId: String?) {
        self.stationId = stationId
        self.address = address
        self.emptySlots = emptySlots
        self.freeBikes = freeBikes
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.status = status
        self.networkId = networkId
    }

    var stationId: String
    var address: String?
    var emptySlots: Int
    var freeBikes: Int
    var latitude: Double
    var longitude: Double
    var distance: Int
    var status: String?
    var networkId: String?

    var id: String {
        stationId
    }
}

class StationModel: ObservableObject {
    @Published var stations: [Station] = []
    
    func fetchStations(location: CLLocationCoordinate2D, distance: Int = 500) {
        let url = "https://citybikes.gaiagreen.tech/near?latitude=\(location.latitude)&longitude=\(location.longitude)&distance=\(distance)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["error"].exists() {
                    print("Server responded with: \(json["error"])")
                } else if !json["near"].exists() {
                    print("Response didn't contain stations")
                } else {
                    self.populateStations(json: json["near"])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func populateStations(json: JSON) {
        for (_, record):(String, JSON) in json {
            let station = Station(json: record)
            self.stations.append(station)
        }
    }
    
    func _populatePreviewData()->StationModel {
        self.stations.append(Station(
            stationId: "1",
            address: "Micer Mascó - Rodriguez Fornos",
            emptySlots: 12,
            freeBikes: 3,
            latitude: 39.47777012539991,
            longitude: -0.359409052701581,
            distance: 50,
            status: "",
            networkId: "valenbisi"
        ))
        self.stations.append(Station(
            stationId: "2",
            address: "Gascó Oliag - Primado Reig",
            emptySlots: 9,
            freeBikes: 13,
            latitude: 39.47670212191253,
            longitude: -0.35905805107551,
            distance: 120,
            status: "",
            networkId: "valenbisi"
        ))
        self.stations.append(Station(
            stationId: "3",
            address: "Gómez Ferrer - Álvaro de Bazán",
            emptySlots: 8,
            freeBikes: 2,
            latitude: 39.47509611584928,
            longitude: -0.361069056238335,
            distance: 140,
            status: "",
            networkId: "valenbisi"
        ))
        self.stations.append(Station(
            stationId: "4",
            address: "Amadeo de Saboya (frente Ayuntamiento)",
            emptySlots: 20,
            freeBikes: 1,
            latitude: 39.47371011075012,
            longitude: -0.362389059448826,
            distance: 200,
            status: "",
            networkId: "valenbisi"
        ))
        return self
    }
}
