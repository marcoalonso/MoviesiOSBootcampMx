//
//  MovieDataModel.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import Foundation

struct MovieDataModel : Codable {
    let results: [DataMovie]
}

struct DataMovie: Codable {
    let backdrop_path: String?
    let id: Int?
    let original_title: String?
    let overview: String?
    let original_language: String?
    let title: String?
    let release_date: String?
    let poster_path: String?
}
