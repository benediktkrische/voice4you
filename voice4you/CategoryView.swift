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
                .toolbarColorScheme(.dark, for: .navigationBar)
                .preferredColorScheme(.light)
                .toolbarBackground(Color("tabBar"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarTitleDisplayMode(.inline)
        }
        
        .navigationTitle(category.name)
        //Color Stack
        .background(Color("bgd"))
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Text("feature in progress..")
                }label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .accentColor(Color("tabBar"))
    }
}

#Preview {
    //CategoryView(tab: .nouns, category: Category(name: "Nouns", id: 0))
    //    .modelContainer(voice4youApp().sharedModelContainer)
    //    .environmentObject(Globals())
    MainView(saveAction: {})
        .environmentObject(Globals())
        .modelContainer(voice4youApp().sharedModelContainer)
}
