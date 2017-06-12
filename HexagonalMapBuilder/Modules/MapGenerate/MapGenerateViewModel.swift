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
    var options: GridGeneratorOptions?
    
    init(title: String?, options: GridGeneratorOptions?) {
        
        self.title = title
        self.options = options
    }
}
