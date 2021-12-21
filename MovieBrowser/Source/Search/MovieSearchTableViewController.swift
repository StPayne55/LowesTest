//
//  MovieSearchTableViewController.swift
//  MovieBrowser
//
//  Created by Payne, Steve on 12/15/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit


class MovieSearchTableViewController: UIViewController {
    private var movies = [Movie]()
    private var selectedMovie: Movie?
    private let viewModel = MovieSearchViewModel()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Lifecycle & Configuration
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    private func configureViews() {
        self.title = "Movie Search"
        searchBar.delegate = self
        searchBar.isTranslucent = false
        searchBar.placeholder = " Search..."
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = UISearchBar.Style.default
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MovieDetailsViewController else { return }

        destinationVC.movie = selectedMovie
    }
}

// MARK: - UITableView Delegate and Datasource
extension MovieSearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard movies.indices.contains(indexPath.row),
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier,
                                                         for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }

        cell.configureCell(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard movies.indices.contains(indexPath.row) else { return }

        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "MovieDetailSegue", sender: nil)
    }
}

// MARK: - UISearchBarDelegate
extension MovieSearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            movies.removeAll()
            self.tableView.reloadData()
            return
        }

        search(query: searchText)
    }

    private func search(query: String) {
        viewModel.searchMovies(query: query) { movies, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alertControl = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OKAY", style: .default, handler: {_ in
                        alertControl.dismiss(animated: true)
                    })

                    alertControl.addAction(okayAction)
                    self.present(alertControl, animated: true)
                }

                guard let movies = movies else { return }
                self.movies.removeAll()
                self.movies = movies
                self.tableView.reloadData()
            }
        }
    }
}

class MovieTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"

    @IBOutlet weak var movieTitleLabel: UILabel?
    @IBOutlet weak var releaseDateLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?

    func configureCell(with movie: Movie) {
        movieTitleLabel?.text = movie.title
        releaseDateLabel?.text = movie.formattedReleaseDate(preferredDateStyle: .long)
        ratingLabel?.text = String(movie.voteAverage)
    }
}
