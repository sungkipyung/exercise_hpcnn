//
//  FlickrAPI.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 2..
//  Copyright © 2016년 hothead. All rights reserved.
//

import Foundation
import Alamofire
import CocoaLumberjack


/**
 https://www.flickr.com/services/feeds/docs/photos_public/
 id (Optional)
 A single user ID. This specifies a user to fetch for.
 ids (Optional)
 A comma delimited list of user IDs. This specifies a list of users to fetch for.
 tags (Optional)
 A comma delimited list of tags to filter the feed by.
 tagmode (Optional)
 Control whether items must have ALL the tags (tagmode=all), or ANY (tagmode=any) of the tags. Default is ALL.
 format (Optional)
 The format of the feed. See the feeds page for feed format information. Default is Atom 1.0.
 lang (Optional)
 The display language for the feed. See the feeds page for feed language information. Default is US English (en-us).
 https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1
 */
class FlickerAPI {
    static let host = "https://api.flickr.com"
    
    class func feed(_ complete:@escaping ([String: Any]?, Error?) -> ()) {
        
        let path = "/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        let url = FlickerAPI.host + path
        
        Alamofire.request(url).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let JSON):
                DDLogDebug("JSON: \(JSON)")
                complete(JSON as? [String: Any], nil)
                break
            case .failure(let error):
                DDLogError(error.localizedDescription)
                complete(nil, error)
                break
            }
        }
    }
}
