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
            
            Text("br")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Breaking Bad", systemImage: "tortoise")
                    
    
                }
            
            Text("beter call saul")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Better Call Saul", systemImage: "briefcase")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
