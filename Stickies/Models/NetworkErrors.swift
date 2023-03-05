//
//  NetworkErrors.swift
//  Stickies
//
//  Created by Ion Caus on 27.02.2023.
//

import Foundation

enum NetworkErrors : Error {
    case badRequest, badURL, unauthorized, invalidServerResponse
    
}
