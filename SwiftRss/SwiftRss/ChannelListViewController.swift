//
//  ChannelListViewController.swift
//  SwiftRss
//
//  Created by lizhenning on 14-6-10.
//  Copyright (c) 2014年 lizhenning. All rights reserved.
//

import UIKit

class ChannelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var channelTitle:NSString?
    var resultArray:NSMutableArray?
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = channelTitle
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame:self.view!.frame)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        self.view!.addSubview(tableView!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return resultArray!.count
    }
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        return 65.0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        var item = resultArray![indexPath.row] as MWFeedItem
        cell.textLabel.text = item.title
        cell.textLabel.numberOfLines = 0
        cell.textLabel.font = UIFont.systemFontOfSize(14)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        self.deleteCellSelected()
        
        var item = resultArray![indexPath.row] as MWFeedItem
        
        var vc = WebViewViewController()
        vc.entity = item
        self.navigationController.pushViewController(vc, animated:true)
    }
    
    
    func deleteCellSelected()
    {
        tableView!.deselectRowAtIndexPath(tableView!.indexPathForSelectedRow(), animated: true)
    }

}
