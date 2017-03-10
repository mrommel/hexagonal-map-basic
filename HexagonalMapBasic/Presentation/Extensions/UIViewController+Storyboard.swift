//
//  UIViewController+Storyboard.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.02.17.
//  Copyright © 2017 MARK BROWNSWORD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard (_ name: String) -> Self? {
        return instantiateFromStoryboard(name, type: self)
    }
    
    fileprivate class func instantiateFromStoryboard<T> (_ name: String, type: T.Type) -> T? {
        guard let viewController = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: self.className()) as? T else {
            return nil
        }
        
        return viewController
    }
}

extension NSObject {
    
    class func className() -> String {
        return String(describing: self.self).components(separatedBy: ".").last!
    }
    
}
