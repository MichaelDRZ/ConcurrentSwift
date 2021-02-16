//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import XCTest
@testable import ConcurrentSwift

class ConcurrentDictionaryTests: XCTestCase {

    // MARK: - Three different dictionary sizes for unit and performance tests
    
    let smallDictSize = 3
    let mediumDictSize = 10_000
    let largeDictSize = 100_000
    
    // MARK: - Some Dummy Closures
    
    let count123: (String, String) -> (Int) = { key, value in
        var count = key.components(separatedBy: "123").count - 1
        count += value.components(separatedBy: "123").count - 1
        return count
    }
    
    let count123Values: (String) -> (Int) = { value in
        return value.components(separatedBy: "123").count - 1
    }
    
    let filter123: (String, String) -> (Bool) = { key, value in
        return key.range(of: "123") != nil || value.range(of: "123") != nil
    }
    
    let reduce123: (String, String) -> (String) = { previousText, text in
        return text.components(separatedBy: "123").reduce(previousText, +)
    }
    
    // MARK: - SetUp & TearDown
    
    var smallDict: [String: String]!
    var mediumDict: [String: String]!
    var largeDict: [String: String]!
    var smallMapResult: [Int]!
    var mediumMapResult: [Int]!
    var largeMapResult: [Int]!
    var smallMapValuesResult: [String: Int]!
    var mediumMapValuesResult: [String: Int]!
    var largeMapValuesResult: [String: Int]!
    var smallCompactMapResult: [Int]!
    var mediumCompactMapResult: [Int]!
    var largeCompactMapResult: [Int]!
    var smallCompactMapValuesResult: [String: Int]!
    var mediumCompactMapValuesResult: [String: Int]!
    var largeCompactMapValuesResult: [String: Int]!
    var smallFilterResult: [String: String]!
    var mediumFilterResult: [String: String]!
    var largeFilterResult: [String: String]!
    
    override func setUp() {
        super.setUp()
        
        let seriesLength = 1000
        
        func generateArrayOfRandomSeries(arraySize: Int) -> [String] {
            guard arraySize > 0 && seriesLength > 0 else { fatalError("Invalid test settings") }
            return (1...arraySize).map({ _ in (1...seriesLength).map({ _ in String(Int.random(in: 0..<10)) }).reduce("", +) })
        }
        
        smallDict = Dictionary(uniqueKeysWithValues: zip(generateArrayOfRandomSeries(arraySize: smallDictSize),
                                                         generateArrayOfRandomSeries(arraySize: smallDictSize)))
        mediumDict = Dictionary(uniqueKeysWithValues: zip(generateArrayOfRandomSeries(arraySize: mediumDictSize),
                                                          generateArrayOfRandomSeries(arraySize: mediumDictSize)))
        largeDict = Dictionary(uniqueKeysWithValues: zip(generateArrayOfRandomSeries(arraySize: largeDictSize),
                                                         generateArrayOfRandomSeries(arraySize: largeDictSize)))
        smallMapResult = smallDict.map(count123)
        mediumMapResult = mediumDict.map(count123)
        largeMapResult = largeDict.map(count123)
        smallMapValuesResult = smallDict.mapValues(count123Values)
        mediumMapValuesResult = mediumDict.mapValues(count123Values)
        largeMapValuesResult = largeDict.mapValues(count123Values)
        smallCompactMapResult = smallDict.compactMap(count123)
        mediumCompactMapResult = mediumDict.compactMap(count123)
        largeCompactMapResult = largeDict.compactMap(count123)
        smallCompactMapValuesResult = smallDict.compactMapValues(count123Values)
        mediumCompactMapValuesResult = mediumDict.compactMapValues(count123Values)
        largeCompactMapValuesResult = largeDict.compactMapValues(count123Values)
        smallFilterResult = smallDict.filter(filter123)
        mediumFilterResult = mediumDict.filter(filter123)
        largeFilterResult = largeDict.filter(filter123)
    }
    
    override func tearDown() {
        super.tearDown()
        smallDict = nil
        mediumDict = nil
        largeDict = nil
        smallMapResult = nil
        mediumMapResult = nil
        largeMapResult = nil
        smallMapValuesResult = nil
        mediumMapValuesResult = nil
        largeMapValuesResult = nil
        smallCompactMapResult = nil
        mediumCompactMapResult = nil
        largeCompactMapResult = nil
        smallCompactMapValuesResult = nil
        mediumCompactMapValuesResult = nil
        largeCompactMapValuesResult = nil
        smallFilterResult = nil
        mediumFilterResult = nil
        largeFilterResult = nil
    }

    // MARK: - Unit Tests
    
    func testConcurrentMap() {
        
        var result = smallDict.concurrentMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Dictionary's\" function \"concurrentMap\" failed.")
        
        result = mediumDict.concurrentMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Dictionary's\" function \"concurrentMap\" failed.")
        
        result = largeDict.concurrentMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Dictionary's\" function \"concurrentMap\" failed.")
    }
    
    func testConcurrentMapValues() {
        
        var result = smallDict.concurrentMapValues(count123Values)
        XCTAssertEqual(result, smallMapValuesResult, "Test for \"Dictionary's\" function \"concurrentMapValues\" failed.")
        
        result = mediumDict.concurrentMapValues(count123Values)
        XCTAssertEqual(result, mediumMapValuesResult, "Test for \"Dictionary's\" function \"concurrentMapValues\" failed.")
        
        result = largeDict.concurrentMapValues(count123Values)
        XCTAssertEqual(result, largeMapValuesResult, "Test for \"Dictionary's\" function \"concurrentMapValues\" failed.")
    }
    
    func testConcurrentCompactMap() {
        
        var result = smallDict.concurrentCompactMap(count123)
        XCTAssertEqual(result, smallMapResult, "Test for \"Dictionary's\" function \"concurrentCompactMap\" failed.")
        
        result = mediumDict.concurrentCompactMap(count123)
        XCTAssertEqual(result, mediumMapResult, "Test for \"Dictionary's\" function \"concurrentCompactMap\" failed.")
        
        result = largeDict.concurrentCompactMap(count123)
        XCTAssertEqual(result, largeMapResult, "Test for \"Dictionary's\" function \"concurrentCompactMap\" failed.")
    }
    
    func testConcurrentCompactMapValues() {
        
        var result = smallDict.concurrentCompactMapValues(count123Values)
        XCTAssertEqual(result, smallMapValuesResult, "Test for \"Dictionary's\" function \"concurrentCompactMapValues\" failed.")
        
        result = mediumDict.concurrentCompactMapValues(count123Values)
        XCTAssertEqual(result, mediumMapValuesResult, "Test for \"Dictionary's\" function \"concurrentCompactMapValues\" failed.")
        
        result = largeDict.concurrentCompactMapValues(count123Values)
        XCTAssertEqual(result, largeMapValuesResult, "Test for \"Dictionary's\" function \"concurrentCompactMapValues\" failed.")
    }
    
    func testConcurrentFilter() {
        
        var result = smallDict.concurrentFilter(filter123)
        XCTAssertEqual(result, smallFilterResult, "Test for \"Dictionary's\" function \"concurrentFilter\" failed.")
        
        result = mediumDict.concurrentFilter(filter123)
        XCTAssertEqual(result, mediumFilterResult, "Test for \"Dictionary's\" function \"concurrentFilter\" failed.")
        
        result = largeDict.concurrentFilter(filter123)
        XCTAssertEqual(result, largeFilterResult, "Test for \"Dictionary's\" function \"concurrentFilter\" failed.")
    }
    
    // MARK: - Performance Test Benchmarks
    
    func testSmallDictMapPerformanceBenchmark() {
        measure {
            _ = smallDict.map(count123)
        }
    }
    
    func testMediumDictMapPerformanceBenchmark() {
        measure {
            _ = mediumDict.map(count123)
        }
    }
    
    func testLargeDictMapPerformanceBenchmark() {
        measure {
            _ = largeDict.map(count123)
        }
    }
    
    func testSmallDictCompactMapPerformanceBenchmark() {
        measure {
            _ = smallDict.compactMap(count123)
        }
    }
    
    func testMediumDictCompactMapPerformanceBenchmark() {
        measure {
            _ = mediumDict.compactMap(count123)
        }
    }
    
    func testLargeDictCompactMapPerformanceBenchmark() {
        measure {
            _ = largeDict.compactMap(count123)
        }
    }
    
    func testSmallDictFilterPerformanceBenchmark() {
        measure {
            _ = smallDict.filter(filter123)
        }
    }
    
    func testMediumDictFilterPerformanceBenchmark() {
        measure {
            _ = mediumDict.filter(filter123)
        }
    }
    
    func testLargeDictFilterPerformanceBenchmark() {
        measure {
            _ = largeDict.filter(filter123)
        }
    }
    
    // MARK: - Performance Tests
    
    func testSmallDictConcurrentMapPerformance() {
        measure {
            _ = smallDict.concurrentMap(count123)
        }
    }
    
    func testMediumDictConcurrentMapPerformance() {
        measure {
            _ = mediumDict.concurrentMap(count123)
        }
    }
    
    func testLargeDictConcurrentMapPerformance() {
        measure {
            _ = largeDict.concurrentMap(count123)
        }
    }
    
    func testSmallDictConcurrentMapValuesPerformance() {
        measure {
            _ = smallDict.concurrentMapValues(count123Values)
        }
    }
    
    func testMediumDictConcurrentMapValuesPerformance() {
        measure {
            _ = mediumDict.concurrentMapValues(count123Values)
        }
    }
    
    func testLargeDictConcurrentMapValuesPerformance() {
        measure {
            _ = largeDict.concurrentMapValues(count123Values)
        }
    }
    
    func testSmallDictConcurrentCompactMapPerformance() {
        measure {
            _ = smallDict.concurrentCompactMap(count123)
        }
    }
    
    func testMediumDictConcurrentCompactMapPerformance() {
        measure {
            _ = mediumDict.concurrentCompactMap(count123)
        }
    }
    
    func testLargeDictConcurrentCompactMapPerformance() {
        measure {
            _ = largeDict.concurrentCompactMap(count123)
        }
    }
    
    func testSmallDictConcurrentCompactMapValuesPerformance() {
        measure {
            _ = smallDict.concurrentCompactMapValues(count123Values)
        }
    }
    
    func testMediumDictConcurrentCompactMapValuesPerformance() {
        measure {
            _ = mediumDict.concurrentCompactMapValues(count123Values)
        }
    }
    
    func testLargeDictConcurrentCompactMapValuesPerformance() {
        measure {
            _ = largeDict.concurrentCompactMapValues(count123Values)
        }
    }
    
    func testSmallDictConcurrentFilterPerformance() {
        measure {
            _ = smallDict.concurrentFilter(filter123)
        }
    }
    
    func testMediumDictConcurrentFilterPerformance() {
        measure {
            _ = mediumDict.concurrentFilter(filter123)
        }
    }
    
    func testLargeDictConcurrentFilterPerformance() {
        measure {
            _ = largeDict.concurrentFilter(filter123)
        }
    }
}
