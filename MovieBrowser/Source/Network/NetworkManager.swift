//
//  Network.swift
//  SampleApp
//
//  Created by Payne, Steve on 12/21/21.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "5885c445eab51c7004916b9c0313e2d3"
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageURL =  "https://image.tmdb.org/t/p/w500/"

    enum EndpointType {
        case movieSearch
        case movieImage
    }

    func searchMovies(queryString: String, completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        guard let url = URL(string: getEndpointURL(for: .movieSearch) + queryString) else {
            completion(.failure((URLError(.unknown))))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let e = error {
                completion(.failure(e))
                return
            }

            guard let d = data else {
                completion(.failure(URLError(.unknown)))
                return
            }

            do {
                let movieResponse = try JSONDecoder().decode(Movies.self, from: d)
                completion(.success(movieResponse.results))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }

    func fetchMovieImage(for movie: Movie, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let url = URL(string: getEndpointURL(for: .movieImage) + (movie.posterPath ?? "")) else {
            completion(.failure((URLError(.unknown))))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let e = error {
                completion(.failure(e))
            }

            guard let d = data else {
                completion(.failure(URLError(.unknown)))
                return
            }

            guard let image = UIImage(data: d) else {
                completion(.failure(URLError(.unknown)))
                return
            }

            completion(.success(image))
        }.resume()
    }

    private func getEndpointURL(for type: EndpointType) -> String {
        switch type {
        case .movieSearch:
            return "\(baseURL)/search/movie?api_key=\(apiKey)&query="
        case .movieImage:
            return imageURL
        }
    }
}
