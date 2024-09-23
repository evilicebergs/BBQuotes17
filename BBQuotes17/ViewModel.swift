//
//  ViewModel.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-26.
//

import Foundation

@Observable
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successRandCharacter
        case simpsonSuccess
        case failed(error: Error)
    }
    enum newFetch {
        case nStarted
        case randomQuote
        case fetching
        case failed(error: Error)
    }
    
    //no one can change this property
    private(set) var status: FetchStatus = .notStarted
    
    private(set) var quoteStatus: newFetch = .nStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Character
    var episode: Episode
    var simpson: Simpson
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Character.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
        
        simpson = Simpson(quote: "test quote", character: "Homer Simpson", image: URL(string: "https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FSeymourSkinner.png?1497567511460")!)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        
        do {
        if Int.random(in: 0...10000) % 10 == 0 {
            simpson = try await fetcher.fetchSimpson()
            
            status = .simpsonSuccess
        } else {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .successQuote
        }
        } catch {
            status = .failed(error: error)
        }
    }
    func getEpisode(for show: String) async {
        status = .fetching
        
        do {
            if let newEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = newEpisode
                
                status = .successEpisode
            }
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getRandCharacter(from show: String) async {
        status = .fetching
        
        do {
            character = try await fetcher.getRandomCharacter()
            if character.productions.contains(show) {
                await getCharacterQuote(for: character.name, from: show)
                status = .successRandCharacter
            } else {
                await getRandCharacter(from: show)
            }
            
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getCharacterQuote(for character: String, from show: String) async {
        quoteStatus = .fetching
        do {
            let quoteTest = try await fetcher.fetchQuote(from: show)
            if quoteTest.character == character {
                quote = quoteTest
                quoteStatus = .randomQuote
            } else {
                await getCharacterQuote(for: character, from: show)
            }
        } catch {
            quoteStatus = .failed(error: error)
        }
    }
    
    
}
