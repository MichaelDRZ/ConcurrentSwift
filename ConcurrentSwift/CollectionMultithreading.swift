//
//  CollectionMultithreading.swift
//  ConcurrentSwift
//
//  Created by Michael Rusterholz on 15 February 2021
//  License: MIT

import Foundation

extension Collection {
    
    /// This internal function initializes tools for performing multithreaded operations on a Collection type.
    /// It returns a serial DispatchQueue for thread-safe operations as well as a number of batches and a batch size.
    /// The number of batches equals three times the number of available cores because the function DispatchQueue.concurrentPerfom requires
    /// at least this number of iterations to balance work efficiently between threads.
    ///
    /// - Returns: A tuple consisting of a serial DispatchQueue, a number of batches and their sizes. The size of the last batch may needs to be reduced if the size of the collection cannot be split into equally sized batches.
    func initializeMultithreading() -> (serialQueue: DispatchQueue,
                                        batchCount: Int,
                                        batchSize: Int) {
        let serialQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialQueue", qos: .userInitiated)
        let batchCount = Swift.min(ProcessInfo.processInfo.activeProcessorCount, count) * 3
        let batchSize = Int(ceil(Double(count) / Double(batchCount)))
        return (serialQueue, batchCount, batchSize)
    }
    
    // This internal function computes the range of a given batch.
    // If the batch would be out of range, nil will be returned.
    /// This internal function computes the range of a given batch (start counting at 0) and a batch size. If the collection cannot be split into
    /// equally sized batches, the last batch will be smaller. If the resulting range would be empty or invalid, nil is returned.
    ///
    /// - Parameter batch: The number of the batch, starting at 0.
    /// - Parameter batchSize: The desired size of the batch (as computed by initializeMultithreading)
    /// - Returns: A range specifying the range of the batch, nil if the range would be empty or otherwise invalid.
    
    func batchRange(for batch: Int, with batchSize: Int) -> Range<Int>? {
        guard batch >= 0 && batchSize > 0 else { return nil }
        let offset = batch * batchSize
        let bound = Swift.min(offset + batchSize, count)
        guard offset < bound else { return nil }
        return offset..<bound
    }
}
