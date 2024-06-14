//
//  SwiftUIView.swift
//  voice4you
//
//  Created by Benedikt Krische on 14.06.24.
//

import SwiftUI

struct SettingsColorView: View {
    @EnvironmentObject var globals: Globals
    
    var body: some View {
        NavigationStack {
            List{
                Picker("Choose a color", selection: $globals.color) {
                    ForEach(Colors.allCases, id: \.self) { color in
                        Label(
                            title: {
                                Text(color.name.capitalized)
                            },
                            icon: {
                                Image(systemName: "circle.fill")
                                    .font(.title)
                                    .frame(height: 40)
                                    .foregroundStyle(color.dark)
                                    .overlay(content: {
                                        LinearGradient(stops: [
                                            Gradient.Stop(color: .init(white: 1, opacity: 0), location: 0.49),
                                            Gradient.Stop(color: color.light, location: 0.5),
                                        ], startPoint: .leading, endPoint: .trailing)
                                        .frame(height: 36)
                                        .clipShape(
                                            Circle()
                                        )
                                    })
                            }
                        )
                        .tag(color)
                    }
                }
                .pickerStyle(.inline)
            }
            .toolbarBackground(globals.color.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Color Scheme")
            .scrollContentBackground(.hidden)
            .background(globals.color.light)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsColorView()
        .environmentObject(Globals())
}
