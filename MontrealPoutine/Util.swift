//
//  Util.swift
//  DemoProject
//
//  Created by Krupa-iMac on 24/07/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func getPath(fileName: String) -> String {
        //return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
        
        //let path = tmpDir.stringByAppendingPathComponent(fileName)
        
        //let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        //let dirs : [String] = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String])!
        
        //return dirs.stringByAppendingPathComponent(fileName)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent(fileName)
        return path
        
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()
        
        var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName as String)
        
        //var bundleDBPath:String? = NSBundle.mainBundle().pathForResource("SwiftClassDB", ofType: "sqlite")
        
        
        //fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        //fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        
        if !fileManager.fileExistsAtPath(dbPath) {
            //let fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName as String)
            let fromPath: String? = ""
            do {
                try fileManager.copyItemAtPath(fromPath!, toPath: dbPath)
            } catch _ {
            }
//            var fromPath: NSString = NSBundle.mainBundle().resourcePath.stringByAppendingPathComponent(fileName)
//            fileManager.copyItemAtPath(fromPath, toPath: dbPath, error: nil)
        }
    }
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
   
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
}