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
    @State var animating = false

    var body: some View {
        Group {
            if model.isLoading && model.stations.count == 0 {
                HStack(alignment: .center) {
                    Image(systemName: "arrow.2.circlepath")
                        .rotationEffect(.degrees(animating ? 360 : 0), anchor: .center)
                        .animation(Animation
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false))
                        .onAppear {
                            self.animating.toggle()
                    }
                }
                .frame(maxHeight: .infinity)
                .navigationBarTitle(Text("Citybikes"))
            } else {
                List {
                    ForEach(model.stations) { station in
                        Button(action: {
                            let center = CLLocationCoordinate2DMake(station.latitude, station.longitude)
                                let placemark = MKPlacemark(coordinate: center, addressDictionary: nil)
                                let mapItem = MKMapItem(placemark: placemark)
                                mapItem.name = station.address
                                mapItem.openInMaps(launchOptions: [
                                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
                                ])
                            },
                            label: {
                                StationCell(station: station)
                                    .frame(height: 60.0)
                            }
                        )
                    }
                }
                .navigationBarTitle(Text("Citybikes"))
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(model: StationModel().populatePreviewData())
            ContentView(model: StationModel().isLoadingPreview())
        }
    }
}
#endif

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
            VStack(alignment: .trailing) {
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
