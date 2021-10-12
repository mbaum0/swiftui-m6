//
//  City_Sights_AppApp.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
