//
//  Category.swift
//  voice4you
//
//  Created by Benedikt Krische on 04.04.24.
//

import Foundation
import SwiftData

@Model
final class Category{
    var id: Int
    var tabId: Int
    var name: String
    var sfSymbolName: String
    var labelDescription: String
    var isStarred: Bool
    var isStandard: Bool
    var timestamp: Date
    
    init(id: Int, tabId: Int, name: String, sfSymbolName: String = "doc.plaintext.fill", labelDescription: String = "e.g. lorum ipsum", isStandard: Bool = false,isStarred: Bool = false, timestamp: Date = Date()) {
        self.tabId = tabId
        self.name = name
        self.sfSymbolName = sfSymbolName
        self.labelDescription = labelDescription
        self.isStarred = isStarred
        self.isStandard = isStandard
        self.timestamp = timestamp
        self.id = id
    }
    
    init(){
        self.id = 0
        self.tabId = 0
        self.name = ""
        self.sfSymbolName = ""
        self.labelDescription = ""
        self.isStarred = false
        self.isStandard = false
        self.timestamp = Date()
    }
    
}
