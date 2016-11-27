//
//  HudView.swift
//  MyLocations
//
//  Created by Alper on 27/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import Foundation
import UIKit

//Head-up Display
class HudView: UIView{
    
    var text = ""
    
    //convenience constructor
    class func hudView(inView view: UIView , animated : Bool) -> HudView {
        
        //add the new HudView object as a subview on top of the “parent” view object. This is the navigation controller’s view so the HUD will cover the entire screen.
        let hudView = HudView(frame: view.bounds)
        print("View bounds : \(view.bounds)")
        print("View frame : \(view.frame)")
        hudView.isOpaque = false
        view.addSubview(hudView)
        
        //It also sets view’s isUserInteractionEnabled property to false. While the HUD is showing you don’t want the user to interact with the screen anymore. The user has already pressed the Done button and the screen is in the process of closing.
        view.isUserInteractionEnabled = false
        
        return hudView
    }
    
    
    //The draw() method is invoked whenever UIKit wants your view to redraw itself. Recall that everything in iOS is event-driven. The view doesn’t draw anything on the screen unless UIKit sends it the draw() event. That means you should never call draw() yourself.
    override func draw(_ rect: CGRect) {
        
        //When working with UIKit or Core Graphics (CG, get it?) you use CGFloat instead of the regular Float or Double.
        let boxWidth : CGFloat = 96
        let boxHeight : CGFloat = 96
        
        //The HUD rectangle should be centered horizontally and vertically on the screen. The size of the screen is given by bounds.size (this really is the size of HudView itself, which spans the entire screen).
        let boxRect = CGRect(x: (bounds.size.width - boxWidth) / 2,
                             y: (bounds.size.height - boxHeight) / 2,
                             width: boxWidth,
                             height: boxHeight)
        
        //UIBezierPath is a very handy object for drawing rectangles with rounded corners. You just tell it how large the rectangle is and how round the corners should be. Then you fill it with an 80% opaque dark gray color.
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        
        /*
           Failable initializers
            To create the UIImage you used if let to unwrap the resulting object. That’s because UIImage(named) is a so-called "failable initializer".
            It is possible that loading the image fails, because there is no image with the specified name or the file doesn’t really contain a valid image.
            That’s why UIImage’s init(named) method is really defined as init?(named). The question mark indicates that this method returns an optional. If there was a problem loading the image, it returns nil instead of a brand spanking new UIImage object.
         */
        
        //This loads the checkmark image into a UIImage object. Then it calculates the position for that image based on the center coordinate of the HUD view (center) and the dimensions of the image (image.size).
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imagePoint)
        }
    }
}



