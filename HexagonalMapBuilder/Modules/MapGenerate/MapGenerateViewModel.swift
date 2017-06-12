//
//  MapGenerateViewModel.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

class MapGenerateViewModel {
    
    var title: String? = ""
    
    var size: MapSize = .small
    var climate: ClimateZoneOption = .earth
    var waterPercentage: Float = 0.5
    var rivers: Int = 3
    
    init(title: String?, size: MapSize, climate: ClimateZoneOption, waterPercentage: Float, rivers: Int) {
        
        self.title = title
        self.size = size
        self.climate = climate
        self.waterPercentage = waterPercentage
        self.rivers = rivers
    }
}
