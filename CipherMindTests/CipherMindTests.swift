//
//  CipherMindTests.swift
//  CipherMindTests
//
//  Created by Eli Manjarrez on 11/21/20.
//

import XCTest
@testable import CipherMind

class CipherMindTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIncorrectGuess() throws {
        // create a model
        var model = CipherMindModel(combinationWidth: 5, maximumAttempts: 12, correctSolution: [1, 2, 3, 4, 5])
        model.addGuess([4, 4, 4, 4, 4])
        model.scoreLatestGuess()
        print("lastest score is \(model.guessesArray.last!)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(model.guessesArray.last!.scores ==
                    [CipherMind.CipherScoreType.CipherScoreTypeCorrectStyle,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyle,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyle,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyle])
    }

    func testCorrectGuess() throws {
        // create a model
        let correctSolution = [5, 5, 0, 2, 3]
        var model = CipherMindModel(combinationWidth: 5, maximumAttempts: 12, correctSolution: correctSolution)
        model.addGuess(correctSolution)
        model.scoreLatestGuess()
        print("lastest score is \(model.guessesArray.last!)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(model.guessesArray.last!.scores ==
                    [CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation,
                     CipherMind.CipherScoreType.CipherScoreTypeCorrectStyleAndLocation])
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
