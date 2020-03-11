//
//  APIServerTests.swift
//  FeedTests
//
//  Created by Maryam Alimohammadi on 2/17/20.
//  Copyright © 2020 Maryam Alimohammadi. All rights reserved.
//

import XCTest
@testable import Feed

class APIServerTests: XCTestCase {
    
    var apiService: APIService!
    
    override func setUp() {
        super.setUp()
        apiService = APIService()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func  testGetTilesSuccessfullyTest(){
        
        let jsonData = "{\"tiles\": [{\"name\": \"image\",\"headline\":\"Tim Cook\",\"subline\": \"CEO of Apple Inc.\",\"data\": \"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jpg\",\"score\": 1}]}".data(using: .utf8)
        let mockSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        apiService.session = mockSession
        let tileExpectation = expectation(description: "tiles")
        apiService.session = mockSession
        var tileResponse : TileResponseModel?
        
        apiService.request() {(result: Result<TileResponseModel, Error>) in
            if case .success(let tiles) = result {
                tileResponse = tiles
                tileExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNotNil(tileResponse)
        }
        
    }
    
    func testGetTilesWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        apiService.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        apiService.request() {(result: Result<TileResponseModel, Error>) in
            if case .failure(let error) = result {
                errorResponse = error
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    
    func testGetTilesWhenEmptyDataReturnsError() {
        
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: nil)
        apiService.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        apiService.request() {(result: Result<TileResponseModel, Error>) in
            if case .failure(let error) = result {
                errorResponse = error
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetTilesInvalidJSONReturnsError() {
        let jsonData = "[{\"t\"}]".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        apiService.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        apiService.request() {(result: Result<TileResponseModel, Error>) in
            if case .failure(let error) = result {
                errorResponse = error
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class MockURLSession: URLSession {
    var cachedUrl: URL?
    private let mockTask: MockTask
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, merror:
            error)
    }
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedUrl = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}


class MockTask: URLSessionDataTask{
    
    let data: Data?
    let urlResponse: URLResponse?
    let merror: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data: Data?, urlResponse: URLResponse?, merror: Error?, completionHandler:((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.merror = merror
        self.completionHandler = completionHandler
        
    }
    
    
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler!(self.data, self.urlResponse, self.merror)
        }
    }
    
}
