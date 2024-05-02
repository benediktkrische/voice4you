//
//  TabBar.swift
//  challange
//
//  Created by Benedikt Krische on 02.12.23.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var globals: Globals
    
    var body: some View {
        VStack{
            ScrollSentence()
                .padding(.bottom, 5)
            ZStack{
                TabBarBackgroundWithButton()
                HStack{
                    HStack{
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Spacer()
                            VStack{
                                Image(systemName: globals.selectedTab == tab ? tab.sfSymbolName + ".fill" : tab.sfSymbolName)
                                    .scaleEffect(globals.selectedTab == tab ? 1.25 : 1.0)
                                    .foregroundStyle(Color("tabBarElements"))
                                    .font(.system(size: 22))
                                    .shadow(radius: 5)
                                    .onTapGesture{
                                        withAnimation(.easeIn(duration: 0.1)){
                                            globals.selectedTab = tab
                                        }
                                        while(!globals.path.isEmpty){
                                            globals.path.removeLast()
                                        }
                                    }.padding(.bottom, 2)
                            }
                            Spacer()
                        }
                    }.frame(width: UIScreen.main.bounds.width - 90, height: nil)
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
        }.background(Color("bgd"))
        
    }
}

struct TabBarBackgroundWithButton: View {
    @EnvironmentObject var globals: Globals
    var body: some View {
        HStack{
            ZStack{
                HStack{
                    //more radius on purpose
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: nil, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                    
                    Spacer()
                }
                HStack{
                    Rectangle()
                        .frame(width: 40, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                    Spacer()
                }
            }.frame(width: UIScreen.main.bounds.width - 80)
            Button(action: {
                globals.isPresentedFinalText.toggle()
                globals.generator.impactOccurred()
            }, label: {
                ZStack{
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(globals.selectedTab.color)
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color("tabBarElements"))
                        .font(.system(size: 34))
                        .shadow(radius: 5)
                }
            })
            Spacer()
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

#Preview {
    TabBar()
        .environmentObject(Globals())
}
