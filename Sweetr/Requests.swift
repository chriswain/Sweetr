//
//  Requests.swift
//  Sweetr
//
//  Created by Christopher Wainwright Aaron on 5/18/15.
//  Copyright (c) 2015 Chris Aaron. All rights reserved.
//

import Foundation
import CoreLocation

class FourSquareRequest {
    
    let API_URL = "https://api.foursquare.com/v2/"
    let CLIENT_ID = "RFJJXXB1CWAJ44PK1PSDZWGHTNHXHGXHMZ31QFT4ON2BJINM"
    let CLIENT_SECRET = "IICKLN40EKQI0O21KSJ3IW0WHYJVBNOJMPJXBE3GMSNXVYDK"
    
    var TOKEN: String? {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().objectForKey("fourSquareToken") as? String
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "fourSquareToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func getVenuesWithLocation(location: CLLocation, completion: (venues: [AnyObject]) -> ()) {
        
        // venues empty array
        var venues: [AnyObject] = []
        
        // run completion closure/block and pass venues array
        completion(venues: venues)
    }
    
    
}

class TwitterRequest {
    
    let API_URL = "https://api.twitter.com/1.1/"
    let API_KEY = "3p7WdbAM3kPeLfYxl8qxU2Gh9"
    let API_SECRET = "jUjvTVLM6bHctnuS8ZeoVYSFyrVq4NozHhQb1OxpfExR8suGBH"
    
    var API_ENCODED: String? {
        
        get {
            
            let str = API_KEY + ":" + API_SECRET
            
            let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
            
            if let encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros) {
                return "Basic " + encoded
            }
            
            return nil
        }
    }
    
    var TOKEN: String? {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().objectForKey("twitterToken") as? String
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "twitterToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func getToken(completion: () -> ()) {
        
        let endpoint = "https://api.twitter.com/oauth2/token?grant_type=client_credentials"
        
        if let url = NSURL(string: endpoint) {
            
            var request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.setValue(API_ENCODED, forHTTPHeaderField: "Authorization")
            
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                var error: NSError? = nil
                
                if let returnInfo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String:AnyObject] {
                    
                    println(returnInfo)
                    
                    self.TOKEN = returnInfo["access_token"] as? String
                    
                    completion()
                    
                }
                
                if let error = error {
                    println(error)
                }
                
                
            })
        }
        
    }
    
    func findPopularFoodTweets(completion: (tweets: [AnyObject]) -> ()) {
        
        if TOKEN == nil {
            
            getToken({ () -> () in
                
                // do something
                self.findPopularFoodTweets(completion)
            })
            
            return
        }
        
        let endpoint = API_URL + "search/tweets.json?q=Food&result_type=popular"
        
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.setValue("Bearer " + TOKEN!, forHTTPHeaderField: "Authorization")
            
            NSURLConnection.sendAsynchronousRequest(request, queue:
                NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                    
                    var error: NSError? = nil
                    
                    if let searchInfo = NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String:AnyObject] {
                        
                        println(searchInfo)
                        
                        if let tweets = searchInfo["statuses"] as? [AnyObject] {
                            
                            println(tweets)
                            completion(tweets: tweets)
                        }
                        
                    }
                    
                    if let error = error {
                        println(error)
                    }
            })
        }
        
        
    }
    
    
}