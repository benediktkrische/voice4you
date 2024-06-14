//
//  Colors.swift
//  voice4you
//
//  Created by Benedikt Krische on 14.06.24.
//

import Foundation
import SwiftUI

enum Colors: Codable, Hashable, CaseIterable, ShapeStyle{
    case yellow
    case green
    case blue
    case purple
    case red
    
    var name: String{
        switch self {
        case .green: return "green"
        case .yellow: return "yellow"
        case .blue: return "blue"
        case .purple: return "purple"
        case .red: return "red"
        }
    }
    
    var light: Color {
        switch self {
        case .yellow: return Color("yellowLight")
        case .green: return Color("greenLight")
        case .blue: return Color("blueLight")
        case .purple: return Color("purpleLight")
        case .red: return Color("redLight")
        }
    }
    
    var dark: Color {
        switch self {
        case .yellow: return Color("yellowDark")
        case .green: return Color("greenDark")
        case .blue: return Color("blueDark")
        case .purple: return Color("purpleDark")
        case .red: return Color("redDark")
        }
    }
}
