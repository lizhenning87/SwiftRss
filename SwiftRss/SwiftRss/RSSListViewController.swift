//
//  RSSListViewController.swift
//  SwiftRss
//
//  Created by lizhenning on 14-6-10.
//  Copyright (c) 2014年 lizhenning. All rights reserved.
//

import UIKit

class RSSListViewController: UIViewController{
    
    var resultArray: NSMutableArray?
    var scrollView: UIScrollView?
    var progress: MBProgressHUD?
    
    var colors = [UIColor.rgbColor(red:111,green:166,blue:217,alpha:1),UIColor.rgbColor(red:228,green:195,blue:83,alpha:1),UIColor.rgbColor(red:61,green:74,blue:93,alpha:1),UIColor.rgbColor(red:201,green:77,blue:63,alpha:1),UIColor.rgbColor(red:127,green:187,blue:157,alpha:1),UIColor.rgbColor(red:76,green:70,blue:118,alpha:1)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "RSS"
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        let plistPath = NSBundle.mainBundle().pathForResource("rsslist",ofType:"plist")
        resultArray = NSMutableArray(contentsOfFile:plistPath)
        
        scrollView = UIScrollView(frame: self.view!.frame)
        self.view!.addSubview(scrollView)
        
        var height:NSInteger = 0
        
        for var i = 0; i < resultArray!.count; i++
        {
            var item = resultArray![i] as NSDictionary
            
            var viewItem = UIView(frame:CGRect(origin:CGPoint(x:i%2*160, y:i/2*160), size:CGSizeMake(160,160)))
            
            viewItem.backgroundColor = colors[i%6]
            
            
            scrollView!.addSubview(viewItem)
            
            var label = UILabel(frame:CGRect(origin:CGPoint(x:0,y:0), size:CGSizeMake(160,160)))
            label.backgroundColor = UIColor.clearColor()
            label.text = item["name"] as NSString
            label.font = UIFont.boldSystemFontOfSize(22)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Center
            label.numberOfLines = 0
            viewItem.addSubview(label)
            
            var btn = UIButton(frame:CGRect(origin:CGPoint(x:0,y:0), size:CGSizeMake(160,160)))
            btn.backgroundColor = UIColor.clearColor()
            btn.addTarget(self,action:"btnItemPressed:",forControlEvents:UIControlEvents.TouchUpInside)
            btn.tag = i
            viewItem.addSubview(btn)
            
            
        }
        
        height = resultArray!.count/2*160
        
     
        
        scrollView!.contentSize = CGSize(width:320,height:height)
        
        progress = MBProgressHUD();
        self.view!.addSubview(progress)
        
    }
    
    func btnItemPressed(sender:UIButton!)
    {
        progress!.show(true)
        
        var tag = sender.tag
        var item = resultArray![tag] as NSDictionary
        
        var title: NSString = item["name"] as NSString
        var array: NSMutableArray
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
            
            var parser = RSSReader(url: NSURL(string:(item["url"] as NSString)))
            parser.completionHandler = {resultArray,result in
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.progress!.hide(true)
                    
                    
                    if result!
                    {
                        
                        NSLog("%@", result!)
                        NSLog("count : %d",resultArray!.count)
                        
                        var vc = ChannelListViewController()
                        vc.channelTitle = title
                        vc.resultArray = resultArray
                        self.navigationController.pushViewController(vc, animated:true)
                        
                    }else
                    {
                        var alert = UIAlertView()
                        //草，这样写是bug
                        //var alert = UIAlertView(title:"提示", message:"解析出错!",delegate:nil,cancelButtonTitle:"确定")
                        alert.title = "提示"
                        alert.addButtonWithTitle("确定")
                        alert.message = "解析出错!"
                        alert.show()
                    }
                    
                    })
                
            }
            
            parser.parse()
            
            
            
            
            
            })
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
