//
//  screen1.swift
//  voice4you
//
//  Created by Benedikt Krische on 06.12.23.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var globals: Globals
    @State var isShowingConfirmationAlert = false
    
    var body: some View {
        NavigationStack(path: $globals.path){
            ZStack{
                VStack{
                    TabView(selection: $globals.selectedTab,
                            content:  {
                        TabPage0()
                            .tag(Tab.nouns)
                        TabPage1()
                            .tag(Tab.verbs)
                        TabPage2()
                            .tag(Tab.adjectives)
                        TabPage3()
                            .tag(Tab.bubble)
                        TabPage4()
                            .tag(Tab.bookmark)
                    })
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    TabBar()
                        .padding(.bottom)
                }
                .background(Color("bgd"))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            //Items toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        globals.isShowingSettings.toggle()
                    }, label: {
                        Label("Settings", systemImage: "gear")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        globals.generator.impactOccurred()
                        withAnimation(.bouncy){
                            globals.sentence = globals.undoSentence.removeLast()
                        }
                    }, label: {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                            .font(.caption)
                    })
                    .disabled(globals.undoSentence == [])
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        globals.generator.impactOccurred()
                        isShowingConfirmationAlert = true
                    }, label: {
                        Label("Delete all", systemImage: "trash")
                    })
                }
            }
            .confirmationDialog("Do you really want to delete all words?", isPresented: $isShowingConfirmationAlert, titleVisibility: .visible) {
                Button("Delete all", role: .destructive) {
                    globals.generator.impactOccurred()
                    globals.undoSentence.append(globals.sentence)
                    withAnimation(.bouncy){
                        globals.sentence = Sentence(words: [])
                    }
                    isShowingConfirmationAlert = false
                }
                Button("Cancel", role: .cancel) {
                    isShowingConfirmationAlert = false
                }
            }
            //disable dark mode
            .preferredColorScheme(.light)
            //Color toolbar
            .toolbarBackground(Color("tabBar"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            //Color Stack
            .background(Color("bgd"))
            .scrollContentBackground(.hidden)
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: Category.self){ category in
                CategoryView(tab: globals.selectedTab, category: category)
            }
            .fullScreenCover(isPresented: $globals.isPresentedFinalText) {
                FinalText()
            }
            .sheet(isPresented: $globals.isShowingSettings, content: {
                Settings()
            })

            .searchable(text: $globals.searchText)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Globals())
        .modelContainer(voice4youApp().sharedModelContainer)
}
