//
//  YellowCow.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 3..
//  Copyright © 2016년 hothead. All rights reserved.
//

import Foundation

protocol YellowCowDelegate: class {
    func yellowCow(_ cow: YellowCow, gotImages imageURLs: [String])
    func yellowCow(_ row: YellowCow, gotError error: Error)
}

/**
 This cow work until die
 */
class YellowCow {
    weak var delegate: YellowCowDelegate?
    
    func work() {
        let parseJSON = YellowCow.parseJSON()
        
        FlickerAPI.feed { [weak self] (json, error) in
            guard let sSelf = self else { return }
            Q.shared.yelloCowProcessingQueue.async {
                if let error = error {
                    sSelf.delegate?.yellowCow(sSelf, gotError: error)
                    return
                }
                
                if let json = json {
                    let urls = parseJSON(json)
                    sSelf.delegate?.yellowCow(sSelf, gotImages: urls)
                    return
                }
            }
        }
    }
    
    /**
     https://www.flickr.com/help/forum/23839/?search=yws
     square = _s
     thumnail = _t
     small = _m (for "mini" i guess, or because "s" was already taken)
     medium = no letter
     large = _b (for "big" probably)
     original = _o
     */
    static private func parseJSON() -> (([String: Any]) -> [String]) {
        return { json in
            guard let items = json["items"] as? Array<Dictionary<String, Any>> else { return [String]() }
            
            var urls = [String]()
            items.forEach { (item) in
                // "media": {"m":"https:\/\/farm6.staticflickr.com\/5599\/30553864094_707635bfdc_m.jpg"},
                if let media = item["media"] as? [String: String] {
                    if let url = media.values.first {
                        urls.append(url)
                    }
                }
            }
            return urls
        }
    }
}
