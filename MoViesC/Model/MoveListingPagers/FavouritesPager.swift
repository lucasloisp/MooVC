//
//  FavouritesPager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation

class FavouritesPager: MovieListingPager {
    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.loadFavourites(page: page) { response in
            if let response = response {
                onSuccess(MoviePage(movies: response.movies, totalResults: response.totalResults, isFirst: response.page == 1))
            } else {
                onSuccess(nil)
            }
        }
    }
}
