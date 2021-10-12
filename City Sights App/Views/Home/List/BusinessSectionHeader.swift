//
//  BusinessSectionHeader.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI

struct BusinessSectionHeader: View {
    
    var title: String
    var body: some View {
        ZStack(alignment:.leading) {
            Rectangle().foregroundColor(.white)
            Text(title).font(.headline)
        }
    }
}

