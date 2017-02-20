//
//  MapViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 20.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let slideImages: NSArray = ["MapTile01", "MapTile02", "MapTile03", "MapTile04", "MapTile05"]
    var kImageWidth: CGFloat = 0
    var kImageHeight: CGFloat = 0
    let kPadding: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = UIScreen.main.bounds
        self.kImageWidth = bounds.size.width
        self.kImageHeight = self.kImageWidth // bounds.size.height
        
        self.setupScrollView()
    }
    
    //MARK: Set Infinite ScrollView
    
    func setupScrollView() {
        
        for i in 0..<slideImages.count {
            self.addBackgroundImage(withName: slideImages[i] as! String, atPosition: i)
        }

        self.scrollView.contentSize = CGSize(width: kImageWidth, height: kImageHeight * CGFloat(slideImages.count))
        //scrInfinite.scrollRectToVisible(CGRect(x: 0, y: 0, width: kImageWidth, height: kImageHeight), animated: false)
        
        var mapsDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Maps", ofType: "plist") {
            mapsDict = NSDictionary(contentsOfFile: path)
        }
        if let mapsDict = mapsDict {
            let maps = mapsDict["Maps"] as! NSArray
            
            for mapDict in maps {
                let dict = mapDict as! NSDictionary
                
                //let title = dict["X"] as! String
                let x = self.kImageWidth * (dict["X"] as! CGFloat)
                let y = self.kImageWidth * (dict["Y"] as! CGFloat)
                let number = dict["Number"] as! NSNumber
                /*let x = self.kImageWidth * (dict["x"] as! NSNumber) as! CGFloat
                let y = self.kImageWidth * (dict["y"] as! NSNumber) as! CGFloat
                let number = (dict["number"] as! NSNumber).intValue*/
                
                self.addButtonAt(x: x, y: y, andNumber: number.intValue)
            }
        }
        
        
        //self.addButtonAt(x: 70, y: 30, andNumber: 2)
    }
    
    func addBackgroundImage(withName imageString: String, atPosition position: Int) {
        
        let image = UIImage(named: imageString)!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: CGFloat(position) * (kImageHeight + kPadding), width: kImageWidth, height: kImageHeight)
        imageView.contentMode = .scaleToFill
        self.scrollView.addSubview(imageView)
    }
    
    func addButtonAt(x: CGFloat, y: CGFloat, andNumber number: Int) {
        
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: 40, height: 40))
        button.setBackgroundImage(UIImage(named: "Bubble"), for: .normal)
        button.setTitle("\(number)", for: UIControlState.normal)
        button.tag = number
        button.addTarget(self, action: #selector(openGame), for: .touchUpInside)
        self.scrollView.addSubview(button)
    }
    
    func openGame(sender: AnyObject) {
        
        print("tag: \(sender.tag)")
        
        let gameViewController = GameViewController.instantiateFromStoryboard("Main")
        //gameViewController.game = sender.tag!
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
