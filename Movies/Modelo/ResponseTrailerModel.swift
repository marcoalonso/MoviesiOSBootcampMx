//
//  ResponseTrailerModel.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 27/05/23.
//

import Foundation

struct ResponseTrailerModel: Codable {
    let id: Int
    let results: [Trailer]
    
}

struct Trailer: Codable {
    let key: String
}
