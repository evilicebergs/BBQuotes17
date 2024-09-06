//
//  RandomCharacterView.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-09-05.
//

import SwiftUI

struct RandomCharacterView: View {
    
    let character: Character
    
    var body: some View {
                VStack(alignment: .leading, content: {
                    Text(character.name)
                        .font(.largeTitle)
                    AsyncImage(url: character.images.randomElement()) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 15))
                    } placeholder: {
                        ProgressView()
                    }
                    
                })
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal, 25)
        }
    }

#Preview {
    RandomCharacterView(character: ViewModel().character)
        //.preferredColorScheme(.dark)
}
