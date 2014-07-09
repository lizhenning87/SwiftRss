//
//  ZNHTTPConnection.swift
//  SwiftRss
//
//  Created by lizhenning on 14-6-9.
//  Copyright (c) 2014年 lizhenning. All rights reserved.
//

import UIKit

var _requestOperationQueue: NSOperationQueue?

class ZNHTTPConnection: NSObject , NSURLConnectionDataDelegate
{
    typealias ZNRequestCompletionHandler = (NSURLResponse?, NSData?, NSError?) -> Void
    
    var url: NSURL
    var method = "GET"
    var body = NSData()
    var headers: Dictionary<String , String> = Dictionary()
    var parameters: Dictionary<String , String> = Dictionary()
    var connection: NSURLConnection?
    var response: NSURLResponse?
    
    @lazy var responseData = NSMutableData()
    
    var completionHandler: ZNRequestCompletionHandler
    
    var contentType: String?
    {
    
    set
    {
        headers["Content-Type"] = newValue
    }
    
    get
    {
        return headers["Content-Type"]
    }
    
    }
    
    var userAgent: String?
    {
    
    set
    {
        headers["User-Agent"] = newValue
    }
    get
    {
        return headers["User-Agent"]
    }
    
    }
    
    init(url: NSURL)
    {
        self.url = url
        completionHandler = {response, data, error in}
        super.init()
    }
    
    func loadWithCompletion(completionHandler: ZNRequestCompletionHandler)
    {
        self.completionHandler = completionHandler
//        loadRequest()
    }
    
    func loadRequest()
    {
        if (parameters.count > 0)
        {
            serializeRequestParameters()
        }
        
        if _requestOperationQueue == nil
        {
            _requestOperationQueue = NSOperationQueue()
            _requestOperationQueue!.maxConcurrentOperationCount = 4
            _requestOperationQueue!.name = "com.test.connection"
        }
        
        
        connection = NSURLConnection(request: urlRequest(), delegate: self)
        connection!.setDelegateQueue(_requestOperationQueue)
        connection!.start()
    }
    
    func urlRequest() -> NSMutableURLRequest
    {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.HTTPBody = body
        for (field,value) in headers
        {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        if (body.length > 0)
        {
            request.setValue(String(body.length), forHTTPHeaderField: "Content-Length")
        }
        
        return request
    }
    
    
    func serializeRequestParameters()
    {
        contentType = "application/x-www-form-urlencoded"
        
        if (method == "GET")
        {
            url = queryParametersURL()
        }else
        {
            body = serializedRequestBody()
        }
        
    }
    
    func serializedRequestBody() -> NSData
    {
        return queryString().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    func queryParametersURL() -> NSURL
    {
        return NSURL(string: url.absoluteString + queryString())
    }
    
    
    func queryString() -> String
    {
        var result = "?"
        var firstPass = true
        
        for (key , value) in parameters
        {
            let encodedKey: NSString = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let encodedValue: NSString = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            result += firstPass ? "\(encodedKey)=\(encodedValue)" : "&\(encodedKey)=\(encodedValue)"
            firstPass = false
        }
        
        return result
    }
    
    func connection(_: NSURLConnection!, error: NSError!)
    {
        completionHandler(nil,nil,error)
    }
    
    func connection(_: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        self.response = response
    }
    
    func connection(_: NSURLConnection!, didReceiveData data: NSData!)
    {
        responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(_: NSURLConnection!) {
        completionHandler(response, responseData, nil)
    }
    
    func defaultUserAgent() -> NSString {
        
        var bundle:NSBundle = NSBundle.mainBundle()
        
        var appName = bundle.objectForInfoDictionaryKey("CFBundleDisplayName")
        
        if !appName
        {
            appName = bundle.objectForInfoDictionaryKey("CFBundleName")
        }
        
        var appVersion : NSString
        var marketingVersionNumber = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as NSString
        var developmentVersionNumber = bundle.objectForInfoDictionaryKey("CFBundleVersion") as NSString
        
        if marketingVersionNumber != nil && developmentVersionNumber != nil
        {
            NSLog("YES")
            if marketingVersionNumber.isEqualToString(developmentVersionNumber)
            {
                appVersion = marketingVersionNumber
            }else
            {
                appVersion = marketingVersionNumber + " rv:" + developmentVersionNumber
            }
            
            
        }else
        {
            appVersion = (marketingVersionNumber != nil ? marketingVersionNumber : developmentVersionNumber)
        }
        
        var device:UIDevice = UIDevice.currentDevice()
        var deviceName = device.model as NSString
        var OSName = device.systemName as NSString
        var OSVersion = device.systemVersion as NSString
        var locale = NSLocale.currentLocale().localeIdentifier as NSString
        
        var strAgent = appName as NSString + " " + appVersion as NSString + " (" + deviceName + "; "
        
        strAgent = strAgent + OSName + " " + OSVersion + "; " + locale + ")"
        
//        var strAgent = appName + " " + appVersion + " (" + deviceName + "; " + OSName + " " + OSVersion + "; " + locale + ")"
        NSLog("agent : %@" , strAgent)
//        return strAgent
        
        return ""
    }
    
}
