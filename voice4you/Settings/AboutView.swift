//
//  AboutView.swift
//  voice4you
//
//  Created by Benedikt Krische on 15.05.24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Text("voice4you")
            .foregroundStyle(.secondary)
        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
            .foregroundStyle(.secondary)
        Text("This app was created by Benedikt Krische, a student at HTL Mössingerstraße (htl-klu.at)")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding()
        HStack{
            Text("©")
            Text(Date.now, format: .dateTime.year())
            Text("Benedikt Krische")
        }
        .foregroundStyle(.secondary)
        
    }
}

#Preview {
    AboutView()
}
