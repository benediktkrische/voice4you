//
//  TabPage4.swift
//  voice4you
//
//  Created by Benedikt Krische on 07.12.23.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct TabPage4: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var globals: Globals
    @State var tab: Tab = .bookmark
    
    @Query(filter: #Predicate<Word> {$0.isStarred == true}, sort: [SortDescriptor(\Word.name)]) private var words: [Word]
    
    var body: some View {
        WordList()
        //Name toolbar
            .navigationTitle(tab.name)
    }
}

#Preview {
    TabPage4()
}
