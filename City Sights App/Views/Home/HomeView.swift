//
//  HomeView.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    @State var selectedBusiness:Business?
    
    var body: some View {
        if model.restaurants.count != 0 || model.sights.count != 0 {
            
            // Navigation view
            NavigationView {
                // Determine list or map view
                if isMapShowing {
                    // show map
                    BusinessMap(selectedBusiness: $selectedBusiness)
                        .ignoresSafeArea()
                        .sheet(item: $selectedBusiness) { business in
                            // create a business detail view instance
                            BusinessDetail(business: business)
                        }
                } else {
                    // show list
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Denver, CO")
                            Spacer()
                            Button("Switch to map view") {
                                self.isMapShowing = true
                            }
                        }
                        Divider()
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                }
            }

        } else {
            // still waiting for data
            ProgressView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

