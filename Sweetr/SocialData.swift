//
//  SocialData.swift
//  Sweetr
//
//  Created by Christopher Wainwright Aaron on 5/18/15.
//  Copyright (c) 2015 Chris Aaron. All rights reserved.
//

import UIKit

private let _singleton = SocialData()

class SocialData: NSObject {
    
        var twitterName = ""

        class func mainData() -> SocialData { return _singleton }
   
}
