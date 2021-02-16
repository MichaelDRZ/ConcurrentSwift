//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import XCTest
@testable import ConcurrentSwift

class ConcurrentSetTests: XCTestCase {

    // MARK: - Three different set sizes for unit and performance tests
    
    let smallSetSize = 3
    let mediumSetSize = 10_000
    let largeSetSize = 100_000
    
    // MARK: - Some Dummy Closures
    
    let count123: (String) -> (Int) = { text in
        return text.components(separatedBy: "123").count - 1
    }
    
    let filter123: (String) -> (Bool) = { text in
        return text.range(of: "123") != nil
    }
    
    // MARK: - SetUp & TearDown
    
    var smallSet: Set<String>!
    var mediumSet: Set<String>!
    var largeSet: Set<String>!
    var smallMapResult: [Int]!
    var mediumMapResult: [Int]!
    var largeMapResult: [Int]!
    var smallFilterResult: Set<String>!
    var mediumFilterResult: Set<String>!
    var largeFilterResult: Set<String>!
    
    override func setUp() {
        super.setUp()
        
        let seriesLength = 1000
        
        func generateArrayOfRandomSeries(arraySize: Int) -> [String] {
            guard arraySize > 0 && seriesLength > 0 else { fatalError("Invalid test settings") }
            return (1...arraySize).map({ _ in (1...seriesLength).map({ _ in String(Int.random(in: 0..<10)) }).reduce("", +) })
        }
        
        smallSet = Set(generateArrayOfRandomSeries(arraySize: smallSetSize))
        mediumSet = Set(generateArrayOfRandomSeries(arraySize: mediumSetSize))
        largeSet = Set(generateArrayOfRandomSeries(arraySize: largeSetSize))
        smallMapResult = smallSet.map(count123)
        mediumMapResult = mediumSet.map(count123)
        largeMapResult = largeSet.map(count123)
        smallFilterResult = smallSet.filter(filter123)
        mediumFilterResult = mediumSet.filter(filter123)
        largeFilterResult = largeSet.filter(filter123)
    }
    
    override func tearDown() {
        super.tearDown()
        smallSet = nil
        mediumSet = nil
        largeSet = nil
        smallMapResult = nil
        mediumMapResult = nil
        largeMapResult = nil
        smallFilterResult = nil
        mediumFilterResult = nil
        largeFilterResult = nil
    }

    // MARK: - Unit Tests
    
    func testConcurrentMap() {
        
        var result = smallSet.concurrentMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Set's\" function \"concurrentMap\" failed.")
        
        result = mediumSet.concurrentMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Set's\" function \"concurrentMap\" failed.")
        
        result = largeSet.concurrentMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Set's\" function \"concurrentMap\" failed.")
    }
    
    func testConcurrentCompactMap() {
        
        var result = smallSet.concurrentCompactMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Set's\" function \"concurrentCompactMap\" failed.")
        
        result = mediumSet.concurrentCompactMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Set's\" function \"concurrentCompactMap\" failed.")
        
        result = largeSet.concurrentCompactMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Set's\" function \"concurrentCompactMap\" failed.")
    }
    
    func testConcurrentFilter() {
        
        var result = smallSet.concurrentFilter(filter123)
        XCTAssertEqual(result, smallFilterResult, "Test for \"Set's\" function \"concurrentFilter\" failed.")
        
        result = mediumSet.concurrentFilter(filter123)
        XCTAssertEqual(result, mediumFilterResult, "Test for \"Set's\" function \"concurrentFilter\" failed.")
        
        result = largeSet.concurrentFilter(filter123)
        XCTAssertEqual(result, largeFilterResult, "Test for \"Set's\" function \"concurrentFilter\" failed.")
    }
    
    // MARK: - Performance Test Benchmarks
    
    func testSmallSetMapPerformanceBenchmark() {
        measure {
            _ = smallSet.map(count123)
        }
    }
    
    func testMediumSetMapPerformanceBenchmark() {
        measure {
            _ = mediumSet.map(count123)
        }
    }
    
    func testLargeSetMapPerformanceBenchmark() {
        measure {
            _ = largeSet.map(count123)
        }
    }
    
    func testSmallSetCompactMapPerformanceBenchmark() {
        measure {
            _ = smallSet.compactMap(count123)
        }
    }
    
    func testMediumSetCompactMapPerformanceBenchmark() {
        measure {
            _ = mediumSet.compactMap(count123)
        }
    }
    
    func testLargeSetCompactMapPerformanceBenchmark() {
        measure {
            _ = largeSet.compactMap(count123)
        }
    }
    
    func testSmallSetFilterPerformanceBenchmark() {
        measure {
            _ = smallSet.filter(filter123)
        }
    }
    
    func testMediumSetFilterPerformanceBenchmark() {
        measure {
            _ = mediumSet.filter(filter123)
        }
    }
    
    func testLargeSetFilterPerformanceBenchmark() {
        measure {
            _ = largeSet.filter(filter123)
        }
    }
    
    // MARK: - Performance Tests
    
    func testSmallSetConcurrentMapPerformance() {
        measure {
            _ = smallSet.concurrentMap(count123)
        }
    }
    
    func testMediumSetConcurrentMapPerformance() {
        measure {
            _ = mediumSet.concurrentMap(count123)
        }
    }
    
    func testLargeSetConcurrentMapPerformance() {
        measure {
            _ = largeSet.concurrentMap(count123)
        }
    }
    
    func testSmallSetConcurrentCompactMapPerformance() {
        measure {
            _ = smallSet.concurrentCompactMap(count123)
        }
    }
    
    func testMediumSetConcurrentCompactMapPerformance() {
        measure {
            _ = mediumSet.concurrentCompactMap(count123)
        }
    }
    
    func testLargeSetConcurrentCompactMapPerformance() {
        measure {
            _ = largeSet.concurrentCompactMap(count123)
        }
    }
    
    func testSmallSetConcurrentFilterPerformance() {
        measure {
            _ = smallSet.concurrentFilter(filter123)
        }
    }
    
    func testMediumSetConcurrentFilterPerformance() {
        measure {
            _ = mediumSet.concurrentFilter(filter123)
        }
    }
    
    func testLargeSetConcurrentFilterPerformance() {
        measure {
            _ = largeSet.concurrentFilter(filter123)
        }
    }
}
