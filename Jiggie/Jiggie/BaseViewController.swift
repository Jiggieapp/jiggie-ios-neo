//
//  BaseViewController.swift
//  MyHealth
//
//  Created by uudshan on 7/8/15.
//  Copyright (c) 2015 senisono. All rights reserved.
//
import UIKit
import UIAlertView_Blocks
import SwiftHEXColors
import SVProgressHUD

class BaseViewController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    // MARK: Navigation Bar
    func setupNavigationBar(translucent translucent: Bool) {
        if translucent {
            self.navigationController?.navigationBar.translucent = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.phPurple().colorWithAlphaComponent(0)
            
            self.extendedLayoutIncludesOpaqueBars = false
            self.automaticallyAdjustsScrollViewInsets = false
        } else {
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor.phPurple()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupNavigationBar(title title: String, translucent: Bool = false) {
        self.setupNavigationBar(translucent: translucent)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.phRegular(16)]
        
        self.navigationItem.title = title
    }
    
    func setupNavigationBar(withImage image: UIImage, translucent: Bool = false) {
        self.setupNavigationBar(translucent: translucent)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        
        self.navigationItem.titleView = imageView
    }
    
    func setupNavigationBar(title title: String, subtitle: String) {
        let label = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 2
        
        let attributedString = NSMutableAttributedString(string: "\(title)\n\(subtitle)")
        let titleRange = NSMakeRange(0, title.characters.count)
        let subtitleRange = NSMakeRange(title.characters.count+1, subtitle.characters.count)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.phRegular(16), range: titleRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.phRegular(13), range: subtitleRange)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: subtitleRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.alignment = .Center
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, (title+subtitle).characters.count))
        
        label.attributedText = attributedString
        label.sizeToFit()
        
        var frame = label.frame
        frame.origin.x = UIScreen.width()/2  - CGRectGetWidth(frame)/2
        frame.origin.y = 3.0
        label.frame = frame
        
        self.navigationItem.titleView = label
    }
    
    func removeNavigationBarSeparator() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.edgesForExtendedLayout = .None
    }
    
    // MARK: --Back Button
    func removeBackButtonTitle() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func removeBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: --Bar Button Item
    func fixedSpaceBarButtonItem(width width: CGFloat = 0) -> UIBarButtonItem {
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        space.width = width
        
        return space
    }
    
    // MARK: --Left Bar Button Item
    func setupLeftNavigationBar(withImage image: UIImage!) {
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(BaseViewController.didTapLeftBarButtonItem(_:)))
        
        self.navigationItem.leftBarButtonItems = [self.fixedSpaceBarButtonItem(), barButtonItem];
    }
    
    func setupLeftNavigationBar(withTitle title: String) {
        let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(BaseViewController.didTapLeftBarButtonItem(_:)))
        barButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont.phBold(13)],
                                             forState: .Normal)
        
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    
    // MARK: --Right Bar Button Item
    func setupRightNavigationBar(withImage image: UIImage!) {
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(BaseViewController.didTapRightBarButtonItem(_:)))
        
        self.navigationItem.rightBarButtonItems = [self.fixedSpaceBarButtonItem(), barButtonItem]
    }
    
    func setupRightNavigationBar(withImage image1: UIImage!, image2: UIImage!) {
        let barButtonItem1 = UIBarButtonItem(image: image1, style: .Plain, target: self, action: #selector(BaseViewController.didTapRightBarButtonItem(_:)))
        barButtonItem1.tag = 1
        let barButtonItem2 = UIBarButtonItem(image: image2, style: .Plain, target: self, action: #selector(BaseViewController.didTapRightBarButtonItem(_:)))
        barButtonItem2.tag = 2
        
        self.navigationItem.rightBarButtonItems = [self.fixedSpaceBarButtonItem(), barButtonItem1, barButtonItem2, self.fixedSpaceBarButtonItem()]
    }
    
    func setupRightNavigationBar(withBarButtonSystemItem barButtonSystemItem: UIBarButtonSystemItem, tintColor: UIColor? = nil) {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonSystemItem, target: self, action: #selector(BaseViewController.didTapRightBarButtonItem(_:)))
        
        if let color = tintColor {
            barButtonItem.tintColor = color
        }
        
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setupRightNavigationBar(withTitle title: String) {
        let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(BaseViewController.didTapRightBarButtonItem(_:)))
        barButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont.phBold(13)],
                                             forState: .Normal)
        
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    
    func enableRightNavigationBar(enable: Bool) {
        if let barButtonItems = self.navigationItem.rightBarButtonItems as [UIBarButtonItem]! {
            for barButtonItem in barButtonItems {
                barButtonItem.enabled = enable
            }
        }
    }
    
    func removeRightBarButtonItems() {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    // MARK: --Navigation Bar Actions
    func didTapLeftBarButtonItem(sender: AnyObject) {
        
    }
    
    func didTapRightBarButtonItem(sender: AnyObject) {
        
    }
    
    // MARK: Views
    
    func clearFields(fromView view: UIView) {
        for view in view.subviews {
            if let textField = view as? UITextField where textField.enabled {
                textField.text = nil
            }
            
            if let textView = view as? UITextView where textView.editable {
                textView.text = nil
            }
        }
        
        self.view.endEditing(true)
    }
    
    // MARK: SVProgressHUD
    /// A wrapper function to show SVProgressHUD
    func showHUD() {
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.show()
    }
    
    /// A wrapper function to dismiss SVProgressHUD
    func dismissHUD() {
        dispatch_async(GlobalPriorityDefaultQueue, { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
        })
    }
    
    // MARK: Alert View
    func showAlertView(withMessage message: String?, cancelButtonTitle: String = "OK", otherButtonTitles: [String]? = nil, tapBlock: UIAlertViewCompletionBlock? = nil) {
        dispatch_async(GlobalMainQueue) {
            UIAlertView.showWithTitle(message,
                                      message: nil,
                                      cancelButtonTitle: cancelButtonTitle,
                                      otherButtonTitles: otherButtonTitles,
                                      tapBlock: tapBlock)
        }
    }
    
    // MARK: Rotation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
}
