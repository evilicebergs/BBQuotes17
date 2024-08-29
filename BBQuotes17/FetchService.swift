//
//  FetchService.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-26.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseUrl = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuote(from show: String) async throws -> Quote {
        //build fetch url
        let quoteURL = baseUrl.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        
        //fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        //decode data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        //return quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Character {
        let characterURL = baseUrl.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Character].self, from: data)
        
        return characters[0]
    }
    
    func fetchDeath(for character: String) async throws -> Death? {
        let fetchURL = baseUrl.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
    
    func fetchEpisode() async throws -> Episode? {
        return nil
    }
}
