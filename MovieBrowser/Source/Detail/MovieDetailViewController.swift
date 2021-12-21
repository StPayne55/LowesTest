//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private var viewModel: MovieDetailsViewModel?
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            configureViewModel(with: movie)
        }
    }

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var posterUnavailableLabel: UILabel!


    // MARK: - View Lifecycle & Configuration
    override func viewDidLoad() {
        configureViews(with: movie)
    }

    private func configureViews(with movie: Movie?) {
        movieTitleLabel.text = movie?.title
        releaseDateLabel.text = "Release Date: \(movie?.formattedReleaseDate(preferredDateStyle: .short) ?? "No Release Date")"
        moviePosterImageView.image = UIImage(named: "movie")
        movieDescriptionLabel.text = movie?.overview
        posterUnavailableLabel.isHidden = movie?.posterPath != nil ? true : false
    }

    private func configureViewModel(with movie: Movie) {
        viewModel = MovieDetailsViewModel()
        viewModel?.delegate = self
        viewModel?.configureDetails(for: movie)
    }
}

// MARK: - MovieImageDelegate
extension MovieDetailsViewController: MovieImageDelegate {
    internal func newImageWasReceived(image: UIImage) {
        moviePosterImageView.image = image
    }
}
