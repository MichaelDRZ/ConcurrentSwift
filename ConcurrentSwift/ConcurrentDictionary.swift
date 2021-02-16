//
//  ConcurrentDictionary.swift
//  ConcurrentSwift
//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import Foundation

public extension Dictionary {
    
    /// Multithreaded implementation of the standard map function.
    ///
    /// - Parameter transform: A mapping closure. transform accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type. transform must not be a throwing closure.
    /// - Returns: An array containing the transformed elements of this sequence.
    
    func concurrentMap<T>(_ transform: ((key: Key, value: Value)) -> T) -> [T] {
        guard !isEmpty else { return [T]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        let array = Array(self)
        
        var batchResults = Array<Array<T>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? array[range!].map(transform) : [T]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return batchResults.flatMap({ $0! })
    }
    
    /// Multithreaded implementation of the standard mapValues function.
    ///
    /// - Parameter transform: A closure that transforms a value. transform accepts each value of the dictionary as its parameter and returns a transformed value of the same or of a different type. transform must not be a throwing closure.
    /// - Returns: A dictionary containing the keys and transformed values of this dictionary.
    
    func concurrentMapValues<T>(_ transform: (Value) -> T) -> Dictionary<Key, T> {
        guard !isEmpty else { return Dictionary<Key, T>() }
        
        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        let array = Array(self)
        
        var batchResults = Array<Array<(Key, T)>?>(repeating: nil, count: batchCount)
        
        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? array[range!].map({ key, value in (key, transform(value))} ) : [(Key, T)]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return Dictionary<Key, T>(uniqueKeysWithValues: batchResults.flatMap({ $0! }))
    }
    
    /// Multithreaded implementation of the standard compactMap function.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value. transform must not be a throwing closure.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    
    func concurrentCompactMap<T>(_ transform: ((key: Key, value: Value)) -> T?) -> [T] {
        guard !isEmpty else { return [T]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        let array = Array(self)
        
        var batchResults = Array<Array<T>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? array[range!].compactMap(transform) : [T]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return batchResults.flatMap({ $0! })
    }
    
    /// Multithreaded implementation of the standard compactMapValues function.
    ///
    /// - Parameter transform: A closure that transforms a value. transform accepts each value of the dictionary as its parameter and returns an optional transformed value of the same or of a different type. transform must not be a throwing closure.
    /// - Returns: A dictionary containing the keys and non-nil transformed values of this dictionary.
    
    func concurrentCompactMapValues<T>(_ transform: (Value) -> T?) -> Dictionary<Key, T> {
        guard !isEmpty else { return Dictionary<Key, T>() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        let array = Array(self)
        
        var batchResults = Array<Array<(Key, T)>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result: [(Key, T)]
            if range != nil {
                result = array[range!].compactMap { key, value in
                    let transformedValue = transform(value)
                    return transformedValue != nil ? (key, transformedValue!) : nil
                }
            } else {
                result = [(Key, T)]()
            }
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return Dictionary<Key, T>(uniqueKeysWithValues: batchResults.flatMap({ $0! }))
    }
    
    /// Multithreaded implementation of the standard filter function.
    ///
    /// - Parameter isIncluded: A closure that takes a key-value pair as its argument and returns a Boolean value indicating whether the pair should be included in the returned dictionary. transform must not be a throwing closure.
    /// - Returns: A dictionary of the key-value pairs that isIncluded allows.
    
    func concurrentFilter(_ isIncluded: (Dictionary<Key, Value>.Element) -> Bool) -> [Key : Value] {
        guard !isEmpty else { return [Key : Value]() }

        let (serialQueue, batchCount, batchSize) = initializeMultithreading()
        let array = Array(self)
        
        var batchResults = Array<Array<Element>?>(repeating: nil, count: batchCount)

        DispatchQueue.concurrentPerform(iterations: batchCount) { batch in
            let range = batchRange(for: batch, with: batchSize)
            let result = range != nil ? array[range!].filter(isIncluded) : [Element]()
            serialQueue.sync {
                batchResults[batch] = result
            }
        }
        return Dictionary(uniqueKeysWithValues: batchResults.flatMap({ $0! }))
    }
}


