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
    
    var body: some View {
        if model.restaurants.count != 0 || model.sights.count != 0 {
            
            // Navigation view
            NavigationView {
                // Determine list or map view
                if isMapShowing {
                    // show map
                } else {
                    // show list
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Denver, CO")
                            Spacer()
                            Text("Switch to map view")
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

