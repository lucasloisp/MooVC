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

}
