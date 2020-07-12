//
//  String+Extension.swift
//  Covid19Tracker
//
//  Created by Maharjan Binish on 2020/07/10.
//

import Foundation

extension String {
    var displayDate: String {
        "\(self.split(separator: ",")[0])\(self.split(separator: ",")[1])"
    }
}
