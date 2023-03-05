//
//  TranslateManager.swift
//  Stickies
//
//  Created by Ion Caus on 26.02.2023.
//

import Foundation

public struct TranslateParams {
    var source: String
    var target: String
    var text:   String
}

public class TranslateManager {
    
    private struct API {
        static let base = "https://translation.googleapis.com/language/translate/v2"
        static let method = "GET"
    }
    
    private var apiKey: String!
    
    public static let shared = TranslateManager()
    
    private init() {
        apiKey = UserDefaults.standard.string(forKey: AppStorageKeys.GoogleTranslateApiKey)
    }
 
    public func translate(params: TranslateParams) async throws -> String {
        guard var urlComponents = URLComponents(string: API.base) else {
            throw NetworkErrors.badURL
        }
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "q", value: params.text))
        queryItems.append(URLQueryItem(name: "source", value: params.source))
        queryItems.append(URLQueryItem(name: "target", value: params.target))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkErrors.badURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.method
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        
        guard let response = response as? HTTPURLResponse,
              case 200...299 = response.statusCode
        else {
            throw NetworkErrors.invalidServerResponse
        }
        
        if response.statusCode == 403 {
            throw NetworkErrors.unauthorized
        }
        
        guard
            let json            = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
            let jsonData        = json["data"]              as? [String: Any],
            let translations    = jsonData["translations"]  as? [[String: String]],
            let translation     = translations.first,
            let translatedText  = translation["translatedText"]
        else {
            throw NetworkErrors.badRequest
        }
        
        return translatedText
    }
}
