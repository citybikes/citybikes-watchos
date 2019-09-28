//
//  WatchMapView.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 27/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//
import SwiftUI

// Taken from https://stackoverflow.com/a/56605981/83055
struct WatchMapView: WKInterfaceObjectRepresentable {
    var latitude: Double
    var longitude: Double

    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<WatchMapView>) -> WKInterfaceMap {
        // Return the interface object that the view displays.
        return WKInterfaceMap()
    }

    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: WKInterfaceObjectRepresentableContext<WatchMapView>) {
        // Update the interface object.
        let span = MKCoordinateSpan(latitudeDelta: 0.02,
                                    longitudeDelta: 0.02)

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: coordinate,
            span: span
        )

        map.setRegion(region)
        
        map.addAnnotation(coordinate, with: .red)
    }
}

struct WatchMapView_Previews: PreviewProvider {
    static var previews: some View {
        WatchMapView(latitude: 39.47777012539991, longitude: -0.359409052701581)
    }
}
