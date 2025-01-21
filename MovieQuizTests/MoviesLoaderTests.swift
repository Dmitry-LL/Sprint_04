import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Movies loaded successfully")
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2, "Expected 2 movies, but got \(movies.items.count)")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 2.0)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Movies loading failed")
        loader.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            case .success:
                XCTFail("Unexpected success")
            }
        }
        waitForExpectations(timeout: 2.0)
    }
}
