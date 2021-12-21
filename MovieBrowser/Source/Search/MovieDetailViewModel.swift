//
//  MovieDetailViewModel.swift
//  MovieBrowser
//
//  Created by Payne, Steve on 12/21/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

protocol MovieImageDelegate: AnyObject {
    func newImageWasReceived(image: UIImage)
}

class MovieDetailsViewModel {
    weak var delegate: MovieImageDelegate?
    var movie: Movie? = nil {
        didSet {
            guard let movie = movie else  { return }

            fetchImage(movie: movie)
        }
    }

    func configureDetails(for movie: Movie?) {
        self.movie = movie
    }

    private func fetchImage(movie: Movie) {
        NetworkManager.shared.fetchMovieImage(for: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.delegate?.newImageWasReceived(image: image)
                case .failure(_): break
                }
            }
        }
    }
}
