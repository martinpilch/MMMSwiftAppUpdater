//
//  MMMSwiftAppUpdater.swift
//  fllwrs
//
//  Created by Martin Pilch on 04/10/16.
//  Copyright © 2015 Martin Pilch. All rights reserved.
//

import Foundation
import UIKit

let kItunesLookupString = "https://itunes.apple.com/lookup?bundleId=%@"
let kItunesURLKey = "app.updater.itunes.url"

public class MMMSwiftAppUpdater: NSObject {
    
    static let sharedInstance = MMMSwiftAppUpdater()
    
    public func openAppstoreURL() -> Bool {
        let path = NSUserDefaults.standardUserDefaults().objectForKey(kItunesURLKey) as? String
        if let iTunesPath = path {
            if let url = NSURL(string: iTunesPath) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                    return true
                }
            }
        }
        return false
    }
    
    public func checkForNewVersionWithCompletion(completion: (Bool, NSURL?) -> Void) {
        if let bundleInfo = NSBundle.mainBundle().infoDictionary {
            if let bundleIdentifier = bundleInfo["CFBundleIdentifier"] as? String {
                if let searchURL = NSURL(string:String(format: kItunesLookupString, bundleIdentifier)) {
                    // make request to check version
                    let session = NSURLSession.sharedSession()
                    let task = session.dataTaskWithURL(searchURL, completionHandler: { [weak self] (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                        if let strongSelf = self {
                            strongSelf.processResponse(response, withData: data, error: error, completion: completion)
                        }
                    })
                    task.resume()
                }
            }
        }
    }
    
    func processResponse(response: NSURLResponse?, withData data:NSData?, error:NSError?, completion: (Bool, NSURL?) -> Void) {
        
        guard let data = data where error == nil else {
            completion(false, nil)
            return
        }
        
        let info: [String: AnyObject]?
        do {
            info = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : AnyObject]
        }
        catch _ {
            completion(false, nil)
            return
        }
        
        guard let results = info!["results"] as? [[String: AnyObject]] else {
            completion(false, nil)
            return
        }
        
        guard let result = results.first as [String: AnyObject]? else {
            completion(false, nil)
            return
        }
        
        var newVersionAvailable = false
        if let version = result["version"] as? String {
            newVersionAvailable = compareCurrentVersionWithVersion(version)
        }
        
        guard let url = result["trackViewUrl"] else {
            completion(false, nil)
            return
        }
        
        let appItunesPath = url.stringByReplacingOccurrencesOfString("&uo=4", withString: "")
        guard let appItunesUrl = NSURL(string: appItunesPath) else {
            completion(false, nil)
            return
        }
        
        NSUserDefaults.standardUserDefaults().setObject(appItunesPath, forKey:kItunesURLKey)
        completion(newVersionAvailable, appItunesUrl);
    }
    
    func compareCurrentVersionWithVersion(version: String) -> Bool {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary {
            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                if version.compare(currentVersion, options: .NumericSearch) == .OrderedDescending {
                    return true
                }
            }
        }
        return false
    }
}