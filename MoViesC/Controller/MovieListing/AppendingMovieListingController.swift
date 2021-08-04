//
//  AppendingMovieListingController.swift
//  MoViesC
//
//  Created by Lucas Lois on 3/8/21.
//

import Foundation

class AppendingMovieListingController: MovieListingController {
    func appendIfNotRepeated(movie: Movie) {
        guard !self.movies.contains(where: { $0.tmbdId == movie.tmbdId }) else {
            return
        }
        self.movies.append(movie)
        collectionView?.reloadData()
    }
}
