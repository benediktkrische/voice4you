//
//  CategoryView.swift
//  voice4you
//
//  Created by Benedikt Krische on 09.12.23.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct CategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var globals: Globals
    @State var tab: Tab
    @State var category: Category
    @Query(filter: #Predicate<Word> {$0.categoryId == 0}, sort: [SortDescriptor(\Word.name)]) private var words: [Word]
    
    var body: some View {
        ZStack{
            WordList(categoryId: category.id)
        }
        .navigationTitle(category.name)
        //Color Stack
        .background(Color("bgd"))
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Text("in progress..")
                }label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .accentColor(Color("tabBar"))
    }
}

#Preview {
    CategoryView(tab: .nouns, category: Category(id: 1, tabId: 1, name: "test"))
        .modelContainer(for: [Word.self, Category.self], inMemory: true)
        .environmentObject(Globals())
}
