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
    let id: Int
    let tabId: Int
    let name: String
    let sfSymbolName: String
    let labelDescription: String
    let isStarred: Bool
    let isStandard: Bool
    let timestamp: Date
    
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
