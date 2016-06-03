//
//  UIKitHelper.swift
//
//
//  Created by uudshan on 07/02/16.
//  Copyright © 2016 senisono. All rights reserved.
//

import SwiftHEXColors
import UIKit

let STATUS_BAR_HEIGHT: CGFloat = 20.0;
let NAVIGATION_BAR_HEIGHT: CGFloat = 44.0;
let TAB_BAR_HEIGHT: CGFloat = 50.0;

extension UIScreen {
    
    /**
     Returns the height of the device screen.
     
     - returns: The device screen height.
     */
    public static func height() -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds)
    }
    
    /**
     Returns the width of the device screen.
     
     - returns: The device screen width.
     */
    public static func width() -> CGFloat {
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    
    /**
     Returns the size of the device screen.
     
     - returns: The device screen size.
     */
    public static func size() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    /**
     Returns the bounds of the device screen.
     
     - returns: The bounds of device screen.
     */
    public static func bounds() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
}


public extension UIColor {
    
    public static func phPurple() -> UIColor {
        return UIColor(hexString: "A32ECF")!
    }
    
    public static func phBlue() -> UIColor {
        return UIColor(hexString: "10BBFF")!
    }
    
    private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness * amount,
                           alpha: alpha)
        } else {
            return self
        }
    }
    
}


private let kHelveticaNeueFont = "HelveticaNeue"
private let kHelveticaNeueMediumFont = "HelveticaNeue-Medium"
private let kHelveticaNeueBoldFont = "HelveticaNeue-Bold"

extension UIFont {
    
    public class func navigationBarTitleFont() -> UIFont {
        return UIFont(name: "ProximaNova-Semibold", size: 16)!
    }
    
    public class func navigationBarSubtitleFont() -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: 13)!
    }
    
    public class func proximaNovaBold(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Bold", size: size)!
    }
    
    public class func proximaNova(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: size)!
    }
    
    public class func proximaNovaSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Semibold", size: size)!
    }
    
    public class func checkFontFamilyNames() {
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
    }
    
}


extension UIImage {
    
    /**
     Resizes image based on its height.
     
     - parameter height:    The new height.
     
     - returns: Image with the new size.
     */
    public func resizeImage(height: CGFloat) -> UIImage {
        let scale = height / self.size.height
        let width = self.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        self.drawInRect(CGRectMake(0, 0, width, height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     Create image from color.
     
     - parameter color:     The UIColor.
     - parameter size:      The Image size.
     
     - returns: Image.
     */
    static func fromColor(color: UIColor, size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


extension UINavigationController {
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}


extension UIImageView {
    
    /// Rotates image to the right.
    public func rotate() {
        autoreleasepool { () -> () in
            let imageToRotate = CIImage(CGImage: (self.image?.CGImage)!)
            let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
            let rotatedImage = imageToRotate.imageByApplyingTransform(transform)
            let extent = rotatedImage.extent
            let context = CIContext(options: nil)
            let newImage = UIImage(CGImage: context.createCGImage(rotatedImage, fromRect: extent))
            
            self.image = newImage
        }
    }
    
}


enum PresentViewAnimatePosition {
    case Center
    case Bottom
}

extension UIView {
    
    // MARK: Animation
    func presentView(viewToPresent: UIView, position: PresentViewAnimatePosition, animated: Bool, completion: (() -> Void)?) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if let window = AppDelegate.sharedDelegate.window {
                let overlayView = UIView(frame: window.bounds)
                overlayView.backgroundColor = UIColor(white: 0, alpha: 0.8)
                window.addSubview(overlayView)
                
                let snapShotView = viewToPresent.snapshotViewAfterScreenUpdates(true)
                
                switch position {
                case .Bottom:
                    if animated {
                        var frame = snapShotView.frame
                        frame.origin.x = (CGRectGetWidth(overlayView.bounds) - CGRectGetWidth(snapShotView.bounds)) / 2
                        frame.origin.y = CGRectGetHeight(overlayView.bounds)
                        snapShotView.frame = frame
                        overlayView.addSubview(snapShotView)
                        
                        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
                            var frame = snapShotView.frame
                            frame.origin.y = CGRectGetHeight(overlayView.bounds) - CGRectGetHeight(viewToPresent.bounds)
                            snapShotView.frame = frame
                        }) { (finished) -> Void in
                            viewToPresent.frame = snapShotView.frame
                            
                            snapShotView.removeFromSuperview()
                            overlayView.addSubview(viewToPresent)
                            
                            if let completion = completion {
                                completion()
                            }
                        }
                    } else {
                        overlayView.addSubview(viewToPresent)
                        
                        var frame = viewToPresent.frame
                        frame.origin.x = (CGRectGetWidth(overlayView.bounds) - CGRectGetWidth(snapShotView.bounds)) / 2
                        frame.origin.y = CGRectGetHeight(overlayView.bounds) - CGRectGetHeight(viewToPresent.bounds)
                        viewToPresent.frame = frame
                        
                        if let completion = completion {
                            completion()
                        }
                    }
                case .Center:
                    if animated {
                        snapShotView.center = CGPointMake(window.center.x, CGRectGetHeight(window.bounds))
                        overlayView.addSubview(snapShotView)
                        
                        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
                            snapShotView.center = overlayView.center
                        }) { (finished) -> Void in
                            snapShotView.removeFromSuperview()
                            overlayView.addSubview(viewToPresent)
                            
                            viewToPresent.center = overlayView.center
                            
                            if let completion = completion {
                                completion()
                            }
                        }
                    } else {
                        overlayView.addSubview(viewToPresent)
                        
                        viewToPresent.center = overlayView.center
                        
                        if let completion = completion {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func dismissView(animated: Bool, completion: (() -> Void)?) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if let window = AppDelegate.sharedDelegate.window {
                let overlayView = window.subviews[window.subviews.count-1]
                let snapShotView = self.snapshotViewAfterScreenUpdates(true)
                var frame = snapShotView.frame
                frame.origin.x = CGRectGetMinX(self.frame)
                frame.origin.y = CGRectGetMinY(self.frame)
                snapShotView.frame = frame
                
                self.removeFromSuperview()
                overlayView.addSubview(snapShotView)
                
                if animated {
                    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
                        var frame = snapShotView.frame
                        frame.origin.y = UIScreen.height() + 10
                        snapShotView.frame = frame
                    }) { (finished) -> Void in
                        snapShotView.removeFromSuperview()
                        overlayView.removeFromSuperview()
                        
                        if let completion = completion {
                            completion()
                        }
                    }
                } else {
                    overlayView.removeFromSuperview()
                    
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
    }
    
}
