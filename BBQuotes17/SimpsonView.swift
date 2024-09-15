//
//  SimpsonView.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-09-15.
//

import SwiftUI

struct SimpsonView: View {
    
    let simpson: Simpson
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\"\(simpson.quote)\"")
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal)
            ZStack(alignment: .bottom) {
                AsyncImage(url: simpson.image) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 370)
                        .padding()
                } placeholder: {
                    ProgressView()
                }
                Text(simpson.character)
                    .padding(3)
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .background(.ultraThinMaterial)
            }
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 50))
            .padding(.horizontal, 25)
        }
        
    }
}

#Preview {
    SimpsonView(simpson: ViewModel().simpson)
        //.preferredColorScheme(.dark)
}
