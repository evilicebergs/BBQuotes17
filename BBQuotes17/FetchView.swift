//
//  QuoteView.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-27.
//

import SwiftUI

struct FetchView: View {
    
    let vm = ViewModel()
    
    let show: String
    
    @State var showCharacterInfo = false
    
    @State var randomCharacter = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //background
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height*1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images.randomElement()) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                        
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                        case .successRandCharacter:
                            RandomCharacterView(character: vm.character)
                                .onTapGesture {
                                    showCharacterInfo.toggle()
                                }
                        case .simpsonSuccess:
                            //sample
                            SimpsonView(simpson: vm.simpson)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    HStack {
                        Button {
                            Task {
                                await vm.getRandCharacter(from: show)
                            }
                        } label: {
                            Text("Get Random Character")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                //.font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color(show.removeSpaces() + "Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color(show.removeSpaces() + "Shadow"), radius: 2)
                                .frame(width: geo.size.width/3.6)
                        }
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                                //.font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color(show.removeSpaces() + "Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color(show.removeSpaces() + "Shadow"), radius: 2)
                                .frame(width: geo.size.width/3.6)
                        }
                        Spacer()
                        Button {
                            Task {
                                await vm.getEpisode(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                //.font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color(show.removeSpaces() + "Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color(show.removeSpaces() + "Shadow"), radius: 2)
                                .frame(width: geo.size.width/3.6)
                        }
                    }
                    .padding(.horizontal, 31)
                    
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            //just puts screen on the center, real size is on bigger one
            .frame(width: geo.size.width, height: geo.size.height)
            
            
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo, content: {
            CharacterView(character: vm.character, show: show, quote: vm.quote)
        })
        .onAppear() {
            let num = Int.random(in: 0...100)
            if num % 2 == 0 {
                Task {
                    await vm.getEpisode(for: show)
                }
            } else {
                Task {
                    await vm.getQuoteData(for: show)
                }
            }
        }
        
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
