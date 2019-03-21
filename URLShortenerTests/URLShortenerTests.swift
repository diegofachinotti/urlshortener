//
//  URLShortenerTests.swift
//  URLShortenerTests
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import Foundation

import XCTest
@testable import URLShortener

class URLShortenerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTinyURLAPIValidURL() {
        
        // Create an expectation.
        let expectation = XCTestExpectation(description: "Tinify valid URL")
        
        // Create a URL for a web page to be tinified.
        if let url = URL(string: "http://www.google.com") {
            
            TinyURLAPI.tinify(url: url, completion: { (shortURL:URL?) in
                
                guard let shortURL = shortURL else {
                    XCTFail("API did not return expected outcome. (nil)")
                    return
                }
                
                if shortURL.absoluteString.isEmpty {
                    XCTFail("API did not return expected outcome. (empty)")
                }
                
                // Fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            })
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTinyURLAPIInvalidURL() {
        
        // Create an expectation.
        let expectation = XCTestExpectation(description: "Tinify valid URL")
        
        // Create a URL for a web page to be tinified.
        if let url = URL(string: "thisshouldnotwork.com") {
            
            TinyURLAPI.tinify(url: url, completion: { (shortURL:URL?) in
                
                guard let _ = shortURL else {
                    expectation.fulfill()
                    return
                }
            })
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }

}
