//
//  MovieDBRouteTests.swift
//  MoViesCTests
//
//  Created by Lucas Lois on 21/7/21.
//

import XCTest
@testable import MoViesC

class MovieDBRouteTests: XCTestCase {
    let apiClient = APIClient.shared

    let someGenre = Genre(name: "Action", tmbdId: 28)

    func testCanRequestForTokenCreation() throws {
        let expectation = self.expectation(description: "API Request")
        var response: Result<RequestTokenCreation, Error>!

        apiClient
            .requestItem(request: MovieDBRoute.createRequestToken) { (result: Result<RequestTokenCreation, Error>) in
                response = result
                expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        switch response {
        case .success(let response):
            XCTAssertTrue(response.success)
            XCTAssertFalse(response.requestToken.isEmpty)
        default:
            XCTFail("The network request failed")
        }
    }

    func testCanRequestGenres() throws {
        let expectation = self.expectation(description: "API Request")
        var response: Result<GenresResponse, Error>!

        apiClient
            .requestItem(request: MovieDBRoute.getGenres) { (result: Result<GenresResponse, Error>) in
                response = result
                expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        switch response {
        case .success(let response):
            XCTAssertFalse(response.genres.isEmpty)
            XCTAssertTrue(response.genres.allSatisfy({ genre in
                genre.name.count > 0 && genre.tmbdId > 0
            }))
        default:
            print(response!)
            XCTFail("The network request failed")
        }
    }

    func testCanRequestMoviesForAGenre() throws {
        let expectation = self.expectation(description: "API Request")
        var response: Result<DiscoverMovieResponse, Error>!

        let request = MovieDBRoute.discoverMoviesByGenre(genre: someGenre)

        apiClient
            .requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
                response = result
                expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        switch response {
        case .success(let response):
            XCTAssertFalse(response.movies.isEmpty)
            XCTAssertEqual(response.page, 1)
            response.movies.forEach { someMovie in
                XCTAssertFalse(someMovie.title.isEmpty)
                XCTAssertNotNil(someMovie.posterUrl)
                let posterUrl = someMovie.posterUrl!.absoluteString
                XCTAssertTrue(posterUrl.hasSuffix(".jpg"), "Pster's url is \(someMovie.posterUrl!)")
            }
        default:
            print(response!)
            XCTFail("The network request failed")
        }
    }

}
