//
//  MovieSearchViewModel.swift
//  MovieBrowser
//
//  Created by Payne, Steve on 12/15/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

class MovieSearchViewModel {
    func searchMovies(query: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        NetworkManager.shared.searchMovies(queryString: query) { result in
            switch result {
            case .success(let movies):
                completion(movies, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
