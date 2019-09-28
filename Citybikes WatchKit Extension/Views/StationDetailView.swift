//
//  StationDetail.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 27/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import SwiftUI

struct StationDetailView: View {
    let station: Station
    
    var body: some View {
        VStack {
            WatchMapView(latitude: station.latitude, longitude: station.longitude)
            HStack {
                HStack {
                    Spacer()
                        .padding(.trailing)
                        .frame(width: 16.0, height: 16.0)
                        .background(Color(red: 1.0, green: 215.0/255.0, blue: 0.0, opacity: 1.0))
                        .mask(Image("bicycle")
                            .resizable()
                            .scaledToFit())
                    
                    Text("\(station.freeBikes)")
                        .font(.headline)
                }
                .padding(.trailing)
                
                HStack {
                    VStack {
                        Image("parking")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: 16.0)
                    Text("\(station.emptySlots)")
                        .font(.headline)
                }
                .padding(.leading)
            }
        }
    }
}

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StationDetailView(station: StationModel()._populatePreviewData().stations[0])
    }
}
