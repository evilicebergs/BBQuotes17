//
//  ContentView.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            FetchView(show: Constants.bbName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bbName, systemImage: "tortoise")
                }
            
            FetchView(show: Constants.bcsName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bcsName, systemImage: "briefcase")
                }
            
            FetchView(show: Constants.ecName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.ecName, systemImage: "car")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
/*
 1 - fetch quote automatically when app launches
 2 - when fetching quote make image random
 3 - fetch random character, dont forget to check production /characters/random
 4 - on characterView add a quote and button to fetch a new random quote /character=Walter+White
 5 - add chance to fetch simpsons quote
 
 */
