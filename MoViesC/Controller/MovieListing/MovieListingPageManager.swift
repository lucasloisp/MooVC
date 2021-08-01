//
//  MovieListingPageManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation

protocol MovieListingPager: AnyObject {
    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void))
}

class MovieListingPageManager {
    var totalItems: Int { return totalMovies }
    var isFetchInProgress: Bool { return _isFetchInProgress }

    private let pager: MovieListingPager
    private var currentPage = 1
    private var totalMovies = 0
    private var _isFetchInProgress: Bool = false

    init(pager: MovieListingPager) {
        self.pager = pager
    }

    func restart() {
        currentPage = 1
        totalMovies = 0
    }

    func fetchPage(completionHandler: @escaping ((MoviePage?) -> Void)) {
        guard !_isFetchInProgress else {
            return
        }
        _isFetchInProgress = true

        let page = currentPage

        self.pager.fetchPage(page: page) { moviePage in
            self._isFetchInProgress = false
            if let moviePage = moviePage {
                self.currentPage += 1
                self.totalMovies = moviePage.totalResults
            }
            completionHandler(moviePage)
        }
    }
}
