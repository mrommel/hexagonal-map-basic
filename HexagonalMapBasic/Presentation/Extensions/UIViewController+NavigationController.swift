//
//  UIViewController+NavigationController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 27.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @discardableResult
    func goBack(animated: Bool) -> UIViewController? {
        return self.navigationController?.popViewController(animated: animated)
    }
    
}
