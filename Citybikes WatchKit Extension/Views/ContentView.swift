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
        .navigationBarTitle(Text("Citybikes"))
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
            VStack(alignment: .leading) {
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
                .padding(.top)
                
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
                .padding(.bottom)
            }
            .frame(width: 50)
            VStack(alignment: .trailing){
                Text("\(station.distance)m")
                    .font(.callout)
                    .fontWeight(.bold)
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


