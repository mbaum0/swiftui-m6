//
//  BusinessSearch.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import Foundation

struct BusinessSearch: Decodable {
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    var center = Coordinate()
}
