//
//  Tab.swift
//  voice4you
//
//  Created by Benedikt Krische on 04.04.24.
//

import Foundation
import SwiftUI

enum Tab: Int, CaseIterable, Codable, Hashable {
    case nouns
    case verbs
    case adjectives
    case bubble
    case bookmark
    
    var number: Int {
        switch self {
        case .nouns: return 0
        case .verbs: return 1
        case .adjectives: return 2
        case .bubble: return 3
        case .bookmark: return 4
        }
    }
    
    var sfSymbolName: String {
        switch self {
        case .nouns: return "house"
        case .verbs: return "book"
        case .adjectives: return "person"
        case .bubble: return "bubble.left"
        case .bookmark: return "bookmark"
        }
    }
    var name: String {
        switch self {
        case .nouns: return "Nouns"
        case .verbs: return "Verbs"
        case .adjectives: return "Adjectives"
        case .bubble: return "Conversation"
        case .bookmark: return "Your Favourites"
        }
    }
}
