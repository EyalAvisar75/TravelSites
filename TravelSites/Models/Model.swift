//
//  Model.swift
//  TravelSites
//
//  Created by eyal avisar on 15/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

private var sites = [
    Site(isCheck: false, country: "Israel", city:"Tel Aviv", name: "Azrieli", image: UIImage(named: "azrieli"), coordinate: CLLocationCoordinate2D(latitude: 32.071259715 , longitude: 34.7885785123)),
    Site(isCheck: false, country: "Israel", city:"Tel Aviv", name: "Fountain", image: UIImage(named: "tlvfountain"), coordinate: CLLocationCoordinate2D(latitude: 32.073499706, longitude: 34.771163582)),
]

struct SiteModel {
    func getSiteModel() -> [Site] {
        return sites
    }
}

struct Site {
    var isCheck: Bool
    let country: String
    let city: String
    let name: String
    let image: UIImage?
    let coordinate: CLLocationCoordinate2D
}

