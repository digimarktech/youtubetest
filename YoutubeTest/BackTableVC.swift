//
//  BackTableVC.swift
//  YoutubeTest
//
//  Created by Marc Aupont on 3/16/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        
        tableArray = ["Videos","Forum","Chatroom"]
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return tableArray.count
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
//        
//        cell.textLabel?.text = tableArray[indexPath.row]
//        
//        return cell
//    }
    
    
}
