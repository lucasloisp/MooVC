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
    var isInFirstPage: Bool { return currentPage == 1 }
    private(set) var isFetchInProgress: Bool = false

    private let pager: MovieListingPager
    private var currentPage = 1
    private var totalMovies = 0

    init(pager: MovieListingPager) {
        self.pager = pager
    }

    func restart() {
        currentPage = 1
        totalMovies = 0
    }

    func fetchPage(currentCount: Int, completionHandler: @escaping ((MoviePage?) -> Void)) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true

        let page = currentPage

        self.pager.fetchPage(page: page) { moviePage in
            self.isFetchInProgress = false
            if let moviePage = moviePage {
                self.currentPage += 1
                self.totalMovies = moviePage.totalResults
            } else {
                self.totalMovies = currentCount
            }
            completionHandler(moviePage)
        }
    }
}
