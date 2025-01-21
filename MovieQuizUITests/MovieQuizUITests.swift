//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//

import XCTest

class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }
    
    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        let expectation = expectation(description: "Wait for poster to change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { expectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Poster image did not change")
    }
    
    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        let expectation = expectation(description: "Wait for poster to change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { expectation.fulfill() }
        waitForExpectations(timeout: 2.0)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Poster image did not change")
        
        let indexLabel = app.staticTexts["Index"]
            XCTAssertEqual(indexLabel.label, "2/10", "Index label did not update")
    }
    
    func testGameFinish() throws {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2.0), "Game results alert did not appear")
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons["Сыграть ещё раз"].exists, "Restart button does not exist")
    }
    
    func testAlertDismiss() throws {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists, "Alert did not appear")
        alert.buttons["Сыграть ещё раз"].tap()
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10", "Index label did not reset after dismissing alert")
    }
}
