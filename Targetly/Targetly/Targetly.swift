//
//  Targetly.swift
//  Targetly
//
//  Created by Targetly on 19/07/2021.
//  Copyright © 2021 Targetly. All rights reserved.
//

import Foundation
import UIKit

public final class Targetly {
    
    let name = "Targetly"
    private static var accessToken: String?
        
    /// Initialize the Targetly SDK
    public class func initialize(accessToken: String) {
        Targetly.accessToken = accessToken
    }
    
    /// Set Device Token for Push Notifications
    public class func setDeviceToken(deviceToken: Data) {
        var params: [String : Any]? = ["device_token": deviceToken.hexString]
        UserDefaults.standard.setValue(deviceToken.hexString, forKey: "device_token_for_targetly")
        UserDefaults.standard.synchronize()
        session.request(url: kDeviceTokenEndpoint, parameters: &params, accessToken: accessToken)
    }
    
    /// Send Feedback
    public class func sendFeedback(score: Double, eventName: String, actionID: String) {
        guard let deviceToken = UserDefaults.standard.string(forKey: "device_token_for_targetly"), deviceToken != "" else {
            NSLog("Error: Set Device Token by calling Targetly.setDeviceToken(deviceToken: deviceToken) inside your AppDelegate class method didRegisterForRemoteNotificationsWithDeviceToken")
            return
        }
        var params: [String : Any]? = ["score": score, "event_name": eventName, "action_id": actionID, "device_token": deviceToken]
        session.request(url: kFeedbackEndpoint, parameters: &params, accessToken: accessToken)
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
