//
//  Helper.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 05/10/2023.
//

import Foundation

public class Helper {
    static var executionStart = Date()
    /**
     Thread information is output with a tag and the time in ms from a start date
     */
    static func printWithThreadInfo(tag: String,
                                    executionStart: Date = executionStart) {
        let diff = abs(Date().distance(to: executionStart))
        print("Thread:\(Thread.current)","tag:\(tag)",
              "isMain:\(Thread.isMainThread)",
              "\(String(format: "%.4f",diff*1000)) ms",
              separator: "\t")
    }
}
