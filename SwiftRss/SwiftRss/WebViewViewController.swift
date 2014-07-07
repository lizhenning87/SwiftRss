//
//  WebViewViewController.swift
//  SwiftRss
//
//  Created by lizhenning on 14-6-10.
//  Copyright (c) 2014年 lizhenning. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    var entity: MWFeedItem?
    var webView: UIWebView?
    var progress: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "详情"
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView = UIWebView(frame:self.view!.frame)
        var url = entity!.link
        var request = NSURLRequest(URL:NSURL(string:url))
        webView!.loadRequest(request)
        webView!.scalesPageToFit = true
        self.view!.addSubview(webView!)
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
