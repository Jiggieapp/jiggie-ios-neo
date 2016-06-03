//
//  FoundationHelper.swift
//
//
//  Created by uudshan on 07/02/16.
//  Copyright © 2016 Mohammad Nuruddin Effendi. All rights reserved.
//

import Foundation
import Alamofire

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalPriorityDefaultQueue: dispatch_queue_t {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
}

public func performFunctionWithDelay(delay: Double, queue: dispatch_queue_t, block: dispatch_block_t) {
    let delay = delay * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    dispatch_after(time, queue, block)
}

public func archive(object: AnyObject, fileName: String) {
    NSKeyedArchiver.archiveRootObject(object, toFile: NSURL.dataDirectory().URLByAppendingPathComponent(fileName).path!)
}

public func unarchive(fileName: String) -> AnyObject? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(NSURL.dataDirectory().URLByAppendingPathComponent(fileName).path!)
}

public func removeArchive(fileName: String) -> Bool {
    let fileManager = NSFileManager.defaultManager()
    
    do {
        try fileManager.removeItemAtPath(NSURL.dataDirectory().URLByAppendingPathComponent(fileName).path!)
        return true
    } catch {
        return false
    }
}


extension String {
    
    public static func urlRequestWithComponents(urlString:String, parameters:[String: AnyObject], imageData:NSData) -> (URLRequestConvertible, NSData) {
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    subscript (i: Int) -> Character {
        return self[(self.startIndex.advancedBy(i))]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range((startIndex.advancedBy(r.startIndex)) ..< (startIndex.advancedBy(r.endIndex))))
    }
    
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    public var trimWhitespace: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    public var escape: String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, self, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    /// Check whether given email address is valid or not.
    func isValidEmailAddress(strict: Bool = false) -> Bool {
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strict ? stricterFilterString : laxString
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluateWithObject(self)
    }
    
}


protocol Currency {}
extension Currency {
    
    /// Add thousand separator format with locale identifier of ID.
    var currencyFormat: String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "id_ID")
        numberFormatter.formatterBehavior = .Behavior10_4
        numberFormatter.numberStyle = .DecimalStyle
        
        guard let number = self as? NSNumber else {
            fatalError("this type \(self) is not convertable to NSNumber")
        }
        
        return numberFormatter.stringFromNumber(number)!
    }
    
    /// remove thousand separator format.
    var defaultFormat: NSNumber {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "id_ID")
        numberFormatter.formatterBehavior = .Behavior10_4
        numberFormatter.numberStyle = .NoStyle
        
        return numberFormatter.numberFromString(String(self))!
    }
}

extension Int: Currency {}
extension Double: Currency {}


extension NSData {
    
    /// Returns cleaned device token
    public var getCleanDeviceToken: String {
        let cleanDeviceToken = self.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        
        return cleanDeviceToken.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
}


extension NSDate {
    
    @nonobjc public static let defaultLocaleIdentifier = "en_US_POSIX"
    @nonobjc public static let defaultGMT = 7
    @nonobjc public static let defaultDateFormat = "dd/MM/yyyy"
    
    
    @nonobjc public static let timestamp = NSDate().timeIntervalSince1970 * 1000
    
    /**
     Create `NSDate`.
     
     - parameter string: The date value in string format.
     - parameter format: The optional date format.
     */
    public class func dateFromString(format: String? = NSDate.defaultDateFormat, string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSDate.defaultLocaleIdentifier)
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSDate.defaultGMT)
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(string)
    }
    
    public class func stringFromDate(date: NSDate, format: String? = NSDate.defaultDateFormat) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSDate.defaultLocaleIdentifier)
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: NSDate.defaultGMT)
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
}


extension NSURL {
    
    /// Returns location of document directory.
    public static func documentDirectory() -> NSURL {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        let url = NSURL(string: documentDirectory)!
        
        return url
    }
    
    /// Returns document directory instead of data directory
    /// if system cannot create data directory.
    public static func dataDirectory() -> NSURL {
        let defaultManager = NSFileManager.defaultManager()
        let url = self.documentDirectory().URLByAppendingPathComponent("Data")
        let path = url.path!
        
        if !defaultManager.fileExistsAtPath(path) {
            do {
                try defaultManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                
                return url
            } catch {
                // Unable to create directory. App will use documents directory.
                return self.documentDirectory()
            }
        } else {
            // Directory already exists.
            return url
        }
    }
    
}


extension NSData {
    
    public func toHexString() -> String {
        return self.arrayOfBytes().toHexString()
    }
    
    public func arrayOfBytes() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
    
    public convenience init(bytes: [UInt8]) {
        self.init(data: NSData.withBytes(bytes))
    }
    
    class public func withBytes(bytes: [UInt8]) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
    
}


public extension _ArrayType where Generator.Element == UInt8 {
    
    public func toHexString() -> String {
        return self.lazy.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
}

extension NSError {
    
    @nonobjc public static let Domain = "\(NSBundle.mainBundle().bundleIdentifier).error"
    
    /**
     Creates an `NSError` with the given error code and failure reason.
     
     - parameter domain:        The optional domain value for custom error
     - parameter code:          The error code.
     - parameter failureReason: The failure reason.
     
     - returns: An `NSError` with the given error optional domain, code and failure reason.
     */
    public class func error(domain domain: String? = nil, code: Int, failureReason: String, suggestion: String? = nil) -> NSError {
        var userInfo = [NSLocalizedDescriptionKey : failureReason]
        
        if let suggestion = suggestion {
            userInfo = [NSLocalizedDescriptionKey : failureReason,
                        NSLocalizedRecoverySuggestionErrorKey : suggestion]
        }
        
        return NSError(domain: domain != nil ? Domain+"."+domain! : Domain,
                       code: code,
                       userInfo: userInfo)
    }
    
    /**
     Creates an `NSError` with the given JSON object from API response.
     
     - parameter json: JSON object from API response.
     
     - returns: An `NSError` with the given JSON object from API response.
     */
    public class func errorWithJSON(json: AnyObject) -> NSError {
        let code = json["code"] as! Int
        let message = json["message"] as! String
        
        return self.error(code: code, failureReason: message)
    }
    
}


extension CollectionType where Generator.Element: Equatable {
    
    /**
     Returns unique values of the given element.
     
     - returns: Unique values.
     */
    public func distinct() -> [Generator.Element] {
        var unique: [Generator.Element] = []
        for item in self {
            if !unique.contains(item) {
                unique.append(item)
            }
        }
        
        return unique
    }
    
}
