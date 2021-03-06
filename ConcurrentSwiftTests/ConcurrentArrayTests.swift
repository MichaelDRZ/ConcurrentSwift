//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import XCTest
@testable import ConcurrentSwift

final class ConcurrentArrayTests: XCTestCase {
    
    // MARK: - Three different array sizes for unit and performance tests
    
    let smallArraySize = 3
    let mediumArraySize = 10_000
    let largeArraySize = 100_000
    
    // MARK: - Some Dummy Closures
    
    let count123: (String) -> (Int) = { text in
        return text.components(separatedBy: "123").count - 1
    }
    
    let filter123: (String) -> (Bool) = { text in
        return text.range(of: "123") != nil
    }
    
    // MARK: - SetUp & TearDown
    
    var smallArray: [String]!
    var mediumArray: [String]!
    var largeArray: [String]!
    var smallMapResult: [Int]!
    var mediumMapResult: [Int]!
    var largeMapResult: [Int]!
    var smallFilterResult: [String]!
    var mediumFilterResult: [String]!
    var largeFilterResult: [String]!
    
    override func setUp() {
        super.setUp()
        
        let seriesLength = 1000
        
        func generateArrayOfRandomSeries(arraySize: Int) -> [String] {
            return (1...arraySize).map({ _ in (1...seriesLength).map({ _ in String(Int.random(in: 0..<10)) }).reduce("", +) })
        }
        
        smallArray = generateArrayOfRandomSeries(arraySize: smallArraySize)
        mediumArray = generateArrayOfRandomSeries(arraySize: mediumArraySize)
        largeArray = generateArrayOfRandomSeries(arraySize: largeArraySize)
        smallMapResult = smallArray.map(count123)
        mediumMapResult = mediumArray.map(count123)
        largeMapResult = largeArray.map(count123)
        smallFilterResult = smallArray.filter(filter123)
        mediumFilterResult = mediumArray.filter(filter123)
        largeFilterResult = largeArray.filter(filter123)
    }
    
    override func tearDown() {
        super.tearDown()
        smallArray = nil
        mediumArray = nil
        largeArray = nil
        smallMapResult = nil
        mediumMapResult = nil
        largeMapResult = nil
        smallFilterResult = nil
        mediumFilterResult = nil
        largeFilterResult = nil
    }
    
    // MARK: - Unit Tests
    
    func testConcurrentMap() {
        
        var result = smallArray.concurrentMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Array's\" function \"concurrentMap\" failed.")
        
        result = mediumArray.concurrentMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Array's\" function \"concurrentMap\" failed.")
        
        result = largeArray.concurrentMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Array's\" function \"concurrentMap\" failed.")
    }
    
    func testConcurrentCompactMap() {
        
        var result = smallArray.concurrentCompactMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Array's\" function \"concurrentCompactMap\" failed.")
        
        result = mediumArray.concurrentCompactMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Array's\" function \"concurrentCompactMap\" failed.")
        
        result = largeArray.concurrentCompactMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Array's\" function \"concurrentCompactMap\" failed.")
    }
    
    func testConcurrentFilter() {
        
        var result = smallArray.concurrentFilter(filter123)
        XCTAssertEqual(result, smallFilterResult, "Test for \"Array's\" function \"concurrentFilter\" failed.")
        
        result = mediumArray.concurrentFilter(filter123)
        XCTAssertEqual(result, mediumFilterResult, "Test for \"Array's\" function \"concurrentFilter\" failed.")
        
        result = largeArray.concurrentFilter(filter123)
        XCTAssertEqual(result, largeFilterResult, "Test for \"Array's\" function \"concurrentFilter\" failed.")
    }
    
    // MARK: - Performance Test Benchmarks
    
    func testSmallArrayMapPerformanceBenchmark() {
        measure {
            _ = smallArray.map(count123)
        }
    }
    
    func testMediumArrayMapPerformanceBenchmark() {
        measure {
            _ = mediumArray.map(count123)
        }
    }
    
    func testLargeArrayMapPerformanceBenchmark() {
        measure {
            _ = largeArray.map(count123)
        }
    }
    
    func testSmallArrayCompactMapPerformanceBenchmark() {
        measure {
            _ = smallArray.compactMap(count123)
        }
    }
    
    func testMediumArrayCompactMapPerformanceBenchmark() {
        measure {
            _ = mediumArray.compactMap(count123)
        }
    }
    
    func testLargeArrayCompactMapPerformanceBenchmark() {
        measure {
            _ = largeArray.compactMap(count123)
        }
    }
    
    func testSmallArrayFilterPerformanceBenchmark() {
        measure {
            _ = smallArray.filter(filter123)
        }
    }
    
    func testMediumArrayFilterPerformanceBenchmark() {
        measure {
            _ = mediumArray.filter(filter123)
        }
    }
    
    func testLargeArrayFilterPerformanceBenchmark() {
        measure {
            _ = largeArray.filter(filter123)
        }
    }
    
    // MARK: - Performance Tests
    
    func testSmallArrayConcurrentMapPerformance() {
        measure {
            _ = smallArray.concurrentMap(count123)
        }
    }
    
    func testMediumArrayConcurrentMapPerformance() {
        measure {
            _ = mediumArray.concurrentMap(count123)
        }
    }
    
    func testLargeArrayConcurrentMapPerformance() {
        measure {
            _ = largeArray.concurrentMap(count123)
        }
    }
    
    func testSmallArrayConcurrentCompactMapPerformance() {
        measure {
            _ = smallArray.concurrentCompactMap(count123)
        }
    }
    
    func testMediumArrayConcurrentCompactMapPerformance() {
        measure {
            _ = mediumArray.concurrentCompactMap(count123)
        }
    }
    
    func testLargeArrayConcurrentCompactMapPerformance() {
        measure {
            _ = largeArray.concurrentCompactMap(count123)
        }
    }
    
    func testSmallArrayConcurrentFilterPerformance() {
        measure {
            _ = smallArray.concurrentFilter(filter123)
        }
    }
    
    func testMediumArrayConcurrentFilterPerformance() {
        measure {
            _ = mediumArray.concurrentFilter(filter123)
        }
    }
    
    func testLargeArrayConcurrentFilterPerformance() {
        measure {
            _ = largeArray.concurrentFilter(filter123)
        }
    }
}

