//
//  FirstViewController.swift
//  Jiggie
//
//  Created by Setiady Wiguna on 5/20/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(.GET, "https://rocky-meadow-1164.herokuapp.com/todo") .responseJSON { response in // 1
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

