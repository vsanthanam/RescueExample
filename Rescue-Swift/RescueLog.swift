//
//  RescueLog.swift
//  Rescue-Swift
//
//  Created by Varun Santhanam on 5/9/18.
//

import Foundation
import os.log

public struct RescueLog {
    
    public static let defaultLog = createLog(category: "Rescue-Swift")
    
    public static func createLog(category: String) -> OSLog {
        
        return OSLog(subsystem: "com.varunsanthanam.Rescue-Swift", category: category)
        
    }
    
}
