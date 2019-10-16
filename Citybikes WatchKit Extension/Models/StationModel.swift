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

    init(stationId: String,
         address: String?,
         emptySlots: Int,
         freeBikes: Int,
         latitude: Double,
         longitude: Double,
         distance: Int,
         status: String?,
         networkId: String?) {
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

    // swiftlint:disable:next identifier_name
    var id: String {
        stationId
    }
}

class StationModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var isLoading: Bool = false

    public func fetchStations(location: CLLocationCoordinate2D,
                              distance: Int = 500,
                              completionHandler: @escaping (Error?) -> Void) {
        self.isLoading = true
        let url = "https://citybikes.gaiagreen.tech/stations/near?latitude=\(location.latitude)"
                  + "&longitude=\(location.longitude)&distance=\(distance)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["error"].exists() {
                    let error = NSError(domain: "", code: 1, userInfo: [
                        "message": "Server responded with: \(json["error"])"
                    ])
                    completionHandler(error)
                } else if !json["near"].exists() {
                    print("Response didn't contain stations")
                    completionHandler(nil)
                } else {
                    self.populateStations(json: json["near"])
                    completionHandler(nil)
                }
            case .failure(let error):
                completionHandler(error)
            }
            self.isLoading = false
        }
    }

    public func nearbyStats(distance: Int = 200) -> (Int, Int) {
        var bikes: Int = 0
        var parkings: Int = 0

        for station in self.stations where station.distance <= distance {
            bikes += station.freeBikes
            parkings += station.emptySlots
        }

        return (bikes, parkings)
    }

    private func populateStations(json: JSON) {
        self.stations.removeAll()
        for (_, record):(String, JSON) in json {
            let station = Station(json: record)
            self.stations.append(station)
        }
    }

#if DEBUG
    // swiftlint:disable:next function_body_length
    func populatePreviewData() -> StationModel {
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

    func isLoadingPreview() -> StationModel {
        isLoading = true
        return self
    }
#endif
}
