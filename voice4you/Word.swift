//
//  Word.swift
//  voice4you
//
//  Created by Benedikt Krische on 04.04.24.
//

import Foundation
import SwiftData

@Model
final class Word {
    var categoryId: Int
    var id: Int
    var name: String
    var isStarred: Bool
    var isStandard: Bool
    var timestamp: Date
    
    init(categoryId: Int, id: Int, name: String = "word", isStarred: Bool = false, isStandard: Bool = false, timestamp: Date = Date()) {
        self.categoryId = categoryId
        self.id = id
        self.name = name
        self.isStarred = isStarred
        self.isStandard = isStandard
        self.timestamp = timestamp
    }
    
    init(){
        self.categoryId = 0
        self.id = 0
        self.name = ""
        self.isStarred = false
        self.isStandard = false
        self.timestamp = Date()
    }
}
