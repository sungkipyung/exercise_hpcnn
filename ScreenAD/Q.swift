//
//  Q.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 3..
//  Copyright © 2016년 hothead. All rights reserved.
//

import Foundation

class Q {
    static let shared = Q()
    
    let yelloCowProcessingQueue = DispatchQueue(label: "org.wendies.hothead.YellowCow")
}
