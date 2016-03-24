//
//  ViewController.swift
//  YoutubeTest
//
//  Created by Marc Aupont on 3/5/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()
    
    var videoArray2 = [Video]()
    
    var delegate:VideoModelDelegate?
    
    
    @IBOutlet var txtSearch: UITextField!
    
    @IBOutlet var menuBtn: UIBarButtonItem!
    //var titleImage = UIImage(named: "psmlogotext.png")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuBtn.target = self.revealViewController()
        menuBtn.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.model.delegate = self
        //self.videos = model.getVideos()
        
        //Fire off request to get videos
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        txtSearch.delegate = self
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var userInput = textField.text!
        print(userInput)
        
        textField.resignFirstResponder()
        model.videoArray.removeAll(keepCapacity: false)
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet", "channelId":"UCul3zsip1IMVyeUySVs4uvg", "q":"\(textField.text!)", "maxResults":"5", "type":"video", "key":"AIzaSyCJ0nChYnqDl9dRRoVpR7nhIMuZvyVgJfU"], encoding: ParameterEncoding.URL , headers: nil).responseJSON { (response) -> Void in
            
            if let JSON = response.result.value {
                
                var arrayOfVideos = [Video]()
                
                for video in JSON["items"] as! NSArray {
                    
                    print(video)
                    
                    
                    //Create a video object off of JSON Response
                    let videoObj = Video()
                    
                    //Get all of the content from the JSON response
                    videoObj.videoId = video.valueForKeyPath("id.videoId") as! String
                    
                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                    
                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    
                    if let highResUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                        
                        videoObj.videoThumbnailUrl = highResUrl
                        
                    }
                    
                    if videoObj.videoTitle != "Private video" {
                        
                        arrayOfVideos.append(videoObj)
                    }
                    
                    
                }
                
                
                //When all of the video objects have been constructed, assign the array to the VideoModel property
                self.videoArray2 = arrayOfVideos
                
                self.videos = self.videoArray2
                
                self.tableView.reloadData()
                
                //Notify the delegate that the data is ready
//                if self.delegate != nil {
//                    
//                    self.delegate!.dataReady()
//                }
            }
            
        }
        
        return true
    }
    
    
    
    
    //MARK: - VideoModel Delegate Method
    
    func dataReady() {
        
        //Access the video objects that have been downloaded
        self.videos = self.model.videoArray
        
        //Tell the tableview to reload
        self.tableView.reloadData()
    }
    
    //MARK: - Tableview Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        
        //Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        //Construct the video thumbnail url
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        //Create an NSURL object
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            
            //Create an NSURLRequest object
            let request = NSURLRequest(URL: videoThumbnailUrl!)
            
            //Create an NSURLSession
            let session = NSURLSession.sharedSession()
            
            //Create a datatask and pass in the request
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    //Get a reference to the imageview element of the cell
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    
                    //Create an image object from the data and assign it to the imageview
                    imageView.image = UIImage(data: data!)
                    
                    if indexPath.row == self.videos.count - 1 {
                        
                        self.model.launchReload()
                    }
                    
                })
                
                
            })
            
            dataTask.resume()
            
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Take note of which video the user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        
        //Call the segue
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Get a reference for the destination view controller
        let detailViewController = segue.destinationViewController as! VideoDetailViewController
        
        //Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
        
    }


}

