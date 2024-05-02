//
//  CustomStyles.swift
//  voice4you
//
//  Created by Benedikt Krische on 04.04.24.
//

import Foundation
import SwiftUI

struct DetailedLabelStyle: LabelStyle {
    @State var description: String
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            VStack{}
            configuration.icon
                .frame(width: 40)
            VStack {
                HStack{
                    configuration.title
                    Spacer()
                }
                HStack{
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
            }
        }
    }
}

struct LabelWithStar: LabelStyle {
    @State var word: Word
    @EnvironmentObject var globals: Globals
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            Spacer()
            Image(systemName: word.isStarred ? "star.fill" : "star")
                .onTapGesture {
                    word.isStarred.toggle()
                    globals.generator.impactOccurred()
                }
        }
    }
}
