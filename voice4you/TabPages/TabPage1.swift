//
//  TabPage1.swift
//  voice4you
//
//  Created by Benedikt Krische on 07.12.23.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct TabPage1: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var globals: Globals
    @State var tab: Tab = .verbs
    @Query(filter: #Predicate<Category> {$0.tabId == 1} ,sort: [SortDescriptor(\Category.name)])
    private var categories: [Category]
    
    var body: some View {
        CategoryList(categories: categories)
        //Name toolbar
            .navigationTitle(tab.name)
    }
}

#Preview {
    TabPage1()
        .environmentObject(Globals())
        .modelContainer(for: Category.self, inMemory: true)
}
