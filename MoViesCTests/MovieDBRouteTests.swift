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

    func testCanValidateToken() throws {
        let expectation = self.expectation(description: "API Request")
        var response: Result<TokenValidationResponse, Error>!

        apiClient
            .requestItem(request: MovieDBRoute.createRequestToken) { (result: Result<RequestTokenCreation, Error>) in
                if case .success(let token) = result {
                    let request = MovieDBRoute.validateTokenWithLogin(username: "lucasloisucudal",
                                                                      password: "AYNtGqxJ9UaagtN",
                                                                      accessToken: token.requestToken)
                    self.apiClient.requestItem(request: request) { (result: Result<TokenValidationResponse, Error>) in
                        response = result
                        expectation.fulfill()
                    }
                }
        }

        waitForExpectations(timeout: 6, handler: nil)

        switch response! {
        case .success(let response):
            XCTAssertTrue(response.success)
        case .failure(let error):
            print(error)
            XCTFail("The network request failed")
        }
    }

    func testCanCreateSession() throws {
        let expectation = self.expectation(description: "API Request")
        var response: Result<SessionIdCreation, Error>!

        apiClient
            .requestItem(request: MovieDBRoute.createRequestToken) { (result: Result<RequestTokenCreation, Error>) in
                if case .success(let requestTokenCreation) = result {
                    let token = requestTokenCreation.requestToken
                    let request = MovieDBRoute.validateTokenWithLogin(
                        username: "lucasloisucudal",
                        password: "AYNtGqxJ9UaagtN",
                        accessToken: token)
                    self.apiClient.requestItem(request: request) { (result: Result<TokenValidationResponse, Error>) in
                        if case .success(_) = result {
                            let request = MovieDBRoute.createSession(accessToken: token)
                            self.apiClient.requestItem(request: request) { (result: Result<SessionIdCreation, Error>) in
                                response = result
                                expectation.fulfill()
                            }
                        }
                    }
                }
            }

        waitForExpectations(timeout: 15, handler: nil)

        switch response! {
        case .success(let response):
            XCTAssertTrue(response.success)
            XCTAssertFalse(response.sessionId.isEmpty)
        case .failure(let error):
            print(error)
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

        let request = MovieDBRoute.discoverMoviesByGenre(genre: someGenre, page: 1)

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
