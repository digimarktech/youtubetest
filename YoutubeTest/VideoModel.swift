//
//  VideoModel.swift
//  YoutubeTest
//
//  Created by Marc Aupont on 3/5/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyCJ0nChYnqDl9dRRoVpR7nhIMuZvyVgJfU"
    let UPLOADS_PLAYLIST_ID = "UUul3zsip1IMVyeUySVs4uvg"
    let TUTORIALS_PLAYLIST_ID = "PLrGWT1KtmLdvF2E9UB2Noxm3M81KPzVE2"
    let CHANNEL_ID = "UCul3zsip1IMVyeUySVs4uvg"
    
    
    var videoArray = [Video]()
    
    var nextPageToken = String?()
    
    var delegate:VideoModelDelegate?
    
    func getFeedVideos() {
        
        //Fetch the videos dynamically through the Youtube Data API
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "maxResults":"10", "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            
            if let JSON = response.result.value {
                
                var arrayOfVideos = [Video]()
                
                self.nextPageToken = String(JSON.valueForKeyPath("nextPageToken")!)
                
                for video in JSON["items"] as! NSArray {
                    
                    //print(video)
                    
                    
                    //Create a video object off of JSON Response
                    let videoObj = Video()
                    
                    //Get all of the content from the JSON response
                    videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    
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
                self.videoArray = arrayOfVideos
                
                //Notify the delegate that the data is ready
                if self.delegate != nil {
                    
                    self.delegate!.dataReady()
                }
            }
        }
    }
    
    func launchReload() {
        
        if nextPageToken != nil {
            
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "maxResults":"10", "pageToken":"\(nextPageToken!)", "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
                
                if let JSON = response.result.value {
                    
                    var arrayOfVideos = [Video]()
                    
                    if let npToken = JSON["nextPageToken"] as? String {
                        
                        self.nextPageToken = npToken
                    }
                    
                    
                    for video in JSON["items"] as! NSArray {
                        
                        //print(video)
                        
                        
                        //Create a video object off of JSON Response
                        let videoObj2 = Video()
                        
                        //Get all of the content from the JSON response
                        videoObj2.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                        
                        videoObj2.videoTitle = video.valueForKeyPath("snippet.title") as! String
                        
                        videoObj2.videoDescription = video.valueForKeyPath("snippet.description") as! String
                        
                        if let highResUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                            
                            videoObj2.videoThumbnailUrl = highResUrl
                            
                        }
                        
                        if videoObj2.videoTitle != "Private video" {
                            
                            arrayOfVideos.append(videoObj2)
                        }
                        
                        
                    }
                    
                    //When all of the video objects have been constructed, assign the array to the VideoModel property
                    
                    self.videoArray = arrayOfVideos
                    
                    
                    
                    
                    
                    //Notify the delegate that the data is ready
                    if self.delegate != nil {
                        
                        self.delegate!.dataReady()
                    }
                }
            }
        }
        
    }
    
//    func videoSearch() {
//        
//        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet", "channelId":CHANNEL_ID, "q":"diatonic", "maxResults":"10", "type":"video", "key":API_KEY], encoding: ParameterEncoding.URL , headers: nil).responseJSON { (response) -> Void in
//            
//            if let JSON = response.result.value {
//                
//                var arrayOfVideos = [Video]()
//                
//                for video in JSON["items"] as! NSArray {
//                    
//                    //print(video)
//                    
//                    
//                    //Create a video object off of JSON Response
//                    let videoObj = Video()
//                    
//                    //Get all of the content from the JSON response
//                    videoObj.videoId = video.valueForKeyPath("id.videoId") as! String
//                    
//                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
//                    
//                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
//                    
//                    if let highResUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
//                        
//                        videoObj.videoThumbnailUrl = highResUrl
//                        
//                    }
//                    
//                    if videoObj.videoTitle != "Private video" {
//                        
//                        arrayOfVideos.append(videoObj)
//                    }
//                    
//                    
//                }
//                
//                //When all of the video objects have been constructed, assign the array to the VideoModel property
//                self.videoArray = arrayOfVideos
//                
//                //Notify the delegate that the data is ready
//                if self.delegate != nil {
//                    
//                    self.delegate!.dataReady()
//                }
//            }
//            
//        }
//    }
    
    
    func getVideos() -> [Video] {
        
        //Create an empty array of Video objects
        var videos = [Video]()
        
        //Create a video object
        let video1 = Video()
        
        //Assign properties
        video1.videoId = "WxzS6CiVQRc"
        
        video1.videoTitle = "Play Like YOU - Transform The \"3\"!!! Piano Masterclass"
        
        video1.videoDescription = "Play Like YOU - Piano Series 3!!! Why be a copy musician when you were created an ORIGINAL!!!ENJOY!!!"
        
        //Append it into the videos array
        videos.append(video1)
        
        
        //Create a video object
        let video2 = Video()
        
        //Assign properties
        video2.videoId = "CXWh1RiIo0M"
        
        video2.videoTitle = "MAJOR \"Feel Good\" Chords!!!"
        
        video2.videoDescription = "This FREE video lesson is to promote the use of \"Infinite\" chords from my \"Play Like YOU\" Video Series.This is a \"simplified\" and slightly embellished bird's eye view of a move and tutorial by Russell Ferrante. Ferrante is an amazing pianist, among many. Although these are fantastic chords when playing live, I prefer to use \"Infinite\" chords, as they never repeat and actually create \"unheard of\" chord progressions (for an example of \"Infinite\" chords, please see my other video @ the 1:14-2:00, here - http://www.youtube.com/watch?v=5Gegv5...).http://prettysimplemusic.com"
        
        //Append it into the videos array
        videos.append(video2)
        
        
        //Create a video object
        let video3 = Video()
        
        //Assign properties
        video3.videoId = "IUtVJf3OZzU"
        
        video3.videoTitle = "Where's the TRANSPOSE Button? Piano Secret #1"
        
        video3.videoDescription = "You don't know it yet, but you already have everything you need to play in ALL 12 KEYS RIGHT NOW!!! The Secret is about to be revealed in less than 5 minutes!!! I re-interpret Jason White's version of \"To God Be The Glory\" in the key of A Natural...He originally recorded it in Ab..."
        
        //Append it into the videos array
        videos.append(video3)
        
        
        //Create a video object
        let video4 = Video()
        
        //Assign properties
        video4.videoId = "2fLHZuCIOck"
        
        video4.videoTitle = "Play That \"AGAIN\" with Bjay Brown - Improv Piano Genius"
        
        video4.videoDescription = "\"Play That AGAIN\" Series This piano instructional series focuses on the real-life application of chords, scales, substitutions and licks. It's one thing to learn \"textbook-style\" piano techniques, but it's another thing to actually apply modern piano techniques used in every day music. Join Bjay Brown, as he takes us on his musical journey from simple songs like the \"ABC\" song and \"I LOVE YOU\", to his riviting rindition and remix of \"Say Yes\", which we've re-titled it to simply, \"SAY WHAT???\""
        
        //Append it into the videos array
        videos.append(video4)
        
        
        //Create a video object
        let video5 = Video()
        
        //Assign properties
        video5.videoId = "5Gegv5akgpM"
        
        video5.videoTitle = "Play Like \"YOU\" - Piano Masterclass + FREE BONUS OVER 4 HOURS!!!"
        
        video5.videoDescription = "http://www.prettysimplemusic.com From beginning to end, let this video series open your musical creativity. If you've never touched a keyboard before, or if you're an advanced musician, our goal is for you to \"Play Like \"YOU\", as you were created an original!!! There is something new that none of us have ever heard and we're waiting on you to flourish and spark a \"new\" sound from within!!! Here are the tools for foundational knowledge and the tools for instant creativity!!!"
        
        //Append it into the videos array
        videos.append(video5)
        
        //Here we are returning videos because this method/function requires it. This line returns the array to the caller
        return videos
    }

}
