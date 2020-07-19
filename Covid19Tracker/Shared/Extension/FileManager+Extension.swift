//
//  FileManager+Extension.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import Foundation

extension FileManager {
    
    static var bgFileName: String {
        return "bg.png"
    }
    
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.binish.Covid19Tracker"
    )!
  }
}
