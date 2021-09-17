//
//  Session.swift
//  Targetly
//
//  Created by Targetly on 27/07/2021.
//  Copyright © 2021 Targetly. All rights reserved.
//

import Foundation
import UIKit

/// - Api store do all Networking stuff
///     - build server request
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///

let session: Session = Session()
let kBaseUrl = "https://targetly.ai"
let kDeviceTokenEndpoint = "/api/customer/token"
let kFeedbackEndpoint = "/api/personalizer/feedback"

final class Session {
    
    /// frequent request attributes
    var attributes: [String: Any] {
        get {
            let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
            let deviceModel = UIDevice.modelName
            let osVersion = UIDevice.current.systemVersion
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

            return [
                "X-Device-Platform": "iOS",
                "X-Device-Id": deviceID,
                "X-Device-Model": deviceModel,
                "X-App-Version": appVersion,
                "X-Device-OS-Version": osVersion,
                "X-Device-Time_Zone": TimeZone.current.identifier,
                "X-Device-Time_Stamp": Date().description
            ]
        }
    }
    
    /**
    Make Request
     - parameter url: request url
     - parameter method: http method of request eg: get, post
     - parameter parameters: body parameters
     */
    func request(url: String, parameters: inout [String: Any]?, accessToken: String?) {
        guard let token = accessToken, token != "" else {
            NSLog("Error: Initialize Targetly Sdk with Access Token")
            return
        }
        let completeUrlString = kBaseUrl + url
        guard let serviceUrl = URL(string: completeUrlString) else { return }
        parameters?.updateValue(attributes, forKey: "attrs")
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-api-key")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(json)")
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
        }.resume()
    }

}
