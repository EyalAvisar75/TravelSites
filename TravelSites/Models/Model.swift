//
//  Model.swift
//  TravelSites
//
//  Created by eyal avisar on 15/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import Foundation
import UIKit

struct SiteModel {
    private var sites = [
        Site(isCheck: false, city:"Tel Aviv", name: "Azrieli", image: UIImage(named: "azrieli")),
        Site(isCheck: false, city:"Tel Aviv", name: "Fountain", image: UIImage(named: "tlvfountain")),
    ]
    
    func getSiteModel() -> [Site] {
        return sites
    }
}

struct Site {
    var isCheck: Bool
    let city: String
    let name: String
    let image: UIImage?
}

