//
//  ContentView.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: StationModel

    var body: some View {
        List {
            ForEach(model.stations) { station in
                StationCell(station: station)
                    .frame(height: 60.0)
            }
        }
        .navigationBarTitle(Text("Citybike"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: StationModel()._populatePreviewData())
    }
}

struct StationCell: View {
    var station: Station
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("\(station.freeBikes)")
                    .font(.headline)
                    
                Text("\(station.emptySlots)")
                    .font(.headline)
            }
            .frame(width: 40)
            VStack(alignment: .trailing){
                Text("200m")
                    .font(.callout)
                    .foregroundColor(Color(red: 1.0, green: 215.0/255.0, blue: 0.0, opacity: 1.0))
                Text(station.address!)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}


