//
//  ConcurrentArray.swift
//  ConcurrentSwift
//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import Foundation

public extension Array {
        
    /// Multithreaded implementation of the standard map function.
    ///
    /// - Parameter transform: A mapping closure. transform accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type. transform must not be a throwing closure.
    /// - Returns: An array containing the transformed elements of this sequence.
    
    func concurrentMap<T>(_ transform: (Element) -> T) -> [T] {
        guard !isEmpty else { return [T]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        var batchResults = Array<Array<T>?>(repeating: nil, count: batchCount)
        
        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? self[range!].map(transform) : [T]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return batchResults.flatMap({ $0! })
    }
    
    /// Multithreaded implementation of the standard compactMap function.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value. transform must not be a throwing closure.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    
    func concurrentCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
        guard !isEmpty else { return [T]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        var batchResults = Array<Array<T>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? self[range!].compactMap(transform) : [T]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return batchResults.flatMap({ $0! })
    }
    
    /// Multithreaded implementation of the standard filter function.
    ///
    /// - Parameter isIncluded: A closure that returns true if an element should be included in the returned value and false otherwise. transform must not be a throwing closure.
    /// - Returns: An array containing only the elements for which isIncluded returns true.
    
    func concurrentFilter(_ isIncluded: (Element) -> Bool) -> [Element] {
        guard !isEmpty else { return [Element]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        var batchResults = Array<Array<Element>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? self[range!].filter(isIncluded) : [Element]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return batchResults.flatMap({ $0! })
    }
}
