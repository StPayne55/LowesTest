//
//  Movies.swift
//  MovieBrowser
//
//  Created by Payne, Steve on 12/15/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let page: Int?
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let voteAverage: Double

    func formattedReleaseDate(preferredDateStyle: DateFormatter.Style) -> String? {
        guard let releaseDate = releaseDate else { return "No release date" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: releaseDate) else { return "No release date" }
        dateFormatter.dateStyle = preferredDateStyle

        return dateFormatter.string(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
