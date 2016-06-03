//
//  NetworkHelper.swift
//
//
//  Created by uudshan on 4/22/15.
//  Copyright (c) 2015 Mohammad Nuruddin Effendi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import SystemConfiguration

class NetworkManager {
    
    static let APIBaseURL = "https://api.jiggieapp.com/app/v3"
    
    /**
     A wrapper function from `Alamofire.request`. Creates a request using the shared manager instance
     for the specified method, URL string, parameters, parameter encoding.
     
     - parameter method:        The HTTP method.
     - parameter URLString:     The URL string.
     - parameter parameters:    The parameters. `nil` by default.
     - parameter encoding:      The parameter encoding. `.URL` by default.
     - parameter isUsingToken:  The parameter token. `nil` by default.
     
     - returns: The created request.
     */
    static func request(method: Alamofire.Method, _ url: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, tokenIsNeeded: Bool = false) -> Request? {
        
        let URLString = APIBaseURL+url.URLString
        let manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        return manager.request(method,
            URLString,
            parameters: parameters,
            encoding: encoding)
    }
    
    /**
     A wrapper function from `Alamofire.upload`. Creates an upload request using the shared manager instance
     for the specified method, URL string, parameters, parameter encoding.
     
     - parameter method:                The HTTP method.
     - parameter URLString:             The URL string.
     - parameter multipartFormData:     The closure used to append body parts to the `MultipartFormData`.
     - parameter encodingCompletion:    The closure called when the `MultipartFormData` encoding is complete.
     
     - returns: The created upload request.
     */
    static func requestWithUpload(method: Alamofire.Method, _ url: URLStringConvertible, multipartFormData: MultipartFormData -> Void, encodingCompletion: (Manager.MultipartFormDataEncodingResult -> Void)?) {
        
        let URLString = APIBaseURL+url.URLString
        let manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        Alamofire.upload(method,
            URLString,
            multipartFormData: multipartFormData,
            encodingCompletion: encodingCompletion)
    }
    
}


class Reachability {
    
    /**
     Check if the device is connected to the internet.
     
     - returns: Connected or not.
     */
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
}
