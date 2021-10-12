//
//  ContentView.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel

    var body: some View {
        
        if model.authorizationState == .notDetermined {
            // show onboarding
        } else if model.authorizationState == .authorizedAlways || model.authorizationState == .authorizedWhenInUse {
            // show home view
            HomeView()
        } else {
            // show denied view
        }
        // Detect location auth status
        // if undetermined, show onboarding
        // if approved, show home view
        // if denied, show denied view
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
