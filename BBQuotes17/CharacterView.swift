//
//  CharacterView.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-29.
//

import SwiftUI

struct CharacterView: View {
    
    let character: Character
    let show: String
    @State var quote: Quote
    @State var arrowRotate = false
    
    let vm = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpace())
                        .resizable()
                        .scaledToFit()
                    ScrollView {
                        TabView {
                            ForEach(character.images, id: \.self) { url in
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .frame(width: geo.size.width/1.2, height: geo.size.height/1.7)
                            .clipShape(.rect(cornerRadius: 25))
                            .padding(.top, 60)
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width/1.2, height: geo.size.height/1.7)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(.top, 60)
                        
                        VStack(alignment: .leading) {
                            switch vm.quoteStatus {
                            case .nStarted:
                                Text(quote.quote)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(.rect(cornerRadius: 25))
                                    .foregroundStyle(.white)
                                    .frame(alignment: .center)
                            case .randomQuote:
                                withAnimation {
                                    Text(quote.quote)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .clipShape(.rect(cornerRadius: 25))
                                        .foregroundStyle(.white)
                                        .frame(alignment: .center)
                                }
                            case .fetching:
                                withAnimation{
                                    HStack(alignment: .center, content: {
                                        Spacer(minLength: 30)
                                        ProgressView()
                                            .padding(.vertical)
                                        Spacer(minLength: 30)
                                    })
                                }
                            case .failed(let error):
                                Text(error.localizedDescription)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(character.name)
                                        .font(.largeTitle)
                                    Text("Portrayed By: \(character.portrayedBy)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Button(action: {
                                    arrowRotate.toggle()
                                    Task {
                                        await vm.getCharacterQuote(for: character.name, from: show)
                                    }
                                    withAnimation {
                                        quote = vm.quote
                                    }
                                    
                                }, label: {
                                    if #available(iOS 18.0, *) {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                            .padding()
                                            .background(.ultraThinMaterial)
                                            .clipShape(.rect(cornerRadius: 15))
                                            .symbolEffect(.rotate, value: arrowRotate)
                                    } else {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                            .padding()
                                            .background(.ultraThinMaterial)
                                            .clipShape(.rect(cornerRadius: 15))
                                    }
                                })
                            }
                            Divider()
                            
                            Text("\(character.name) Character Info")
                                .font(.title2)
                            
                            Text("Born: \(character.birthday)")
                            Divider()
                            Text("Occupations:")
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("•" + occupation)
                                    .font(.subheadline)
                            }
                            Divider()
                            Text("Nicknames:")
                            
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text("•" + alias)
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            Divider()
                            
                            DisclosureGroup("Status (spoiler alert!)") {
                                VStack(alignment: .leading, content: {
                                    Text(character.status)
                                        .font(.title2)
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear {
                                                    withAnimation {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Text("How \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                })
                                .frame(width: geo.size.width/1.25, alignment: .leading)
                                
                            }
                            .tint(.primary)
                            
                        }
                        .frame(width: geo.size.width/1.25, alignment: .leading)
                        .padding(.bottom, 50)
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                    .onAppear() {
                        
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            
        })
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName, quote: ViewModel().quote)
        .preferredColorScheme(.dark)
}
