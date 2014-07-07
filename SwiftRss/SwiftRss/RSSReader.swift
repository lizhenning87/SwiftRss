//
//  RSSReader.swift
//  SwiftRss
//
//  Created by lizhenning on 14-6-10.
//  Copyright (c) 2014年 lizhenning. All rights reserved.
//

import UIKit

class RSSReader: NSObject , MWFeedParserDelegate{
   
    typealias RSSReaderHandler = (NSMutableArray?, Bool?) -> Void
    
    var resultArray: NSMutableArray = NSMutableArray()
    var result:Bool = false
    var parserURL: NSURL?
    var completionHandler: RSSReaderHandler
    
    init(url: NSURL)
    {
        parserURL = url
        completionHandler = {resultArray,result in}
        super.init()
    }
    
    func setCompletion(completionHandler: RSSReaderHandler)
    {
        self.completionHandler = completionHandler
    }
    
    func parse()
    {
        
        let parser = MWFeedParser(feedURL: parserURL)
        parser.delegate = self
        parser.parse()
    }
    
    
    func feedParserDidStart(parser: MWFeedParser) {
        NSLog("begin")
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        NSLog("title : %@", item.title)
        resultArray.addObject(item)
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        
        NSLog("finish")
        
        completionHandler(resultArray,true)
        
    }
    
    func feedParser(parser: MWFeedParser, didFailWithError error: NSError) {
        
        NSLog("fail")
        
        completionHandler(resultArray,false)
    }
    
}
