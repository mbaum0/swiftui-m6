//
//  BusinessSection.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI

struct BusinessSection: View {
    var title: String
    var businesses: [Business]
    var body: some View {
        Section(header: BusinessSectionHeader(title: title)) {
            ForEach(businesses) {business in
                NavigationLink(destination: BusinessDetail(business: business)){
                    BusinessRow(business:business)
                }
            }
        }
    }
}
