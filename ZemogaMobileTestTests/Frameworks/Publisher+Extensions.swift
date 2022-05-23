//
//  Publisher+Extensions.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import Foundation
import Combine
@testable import ZemogaMobileTest

extension Publisher {
    
    public func toBlocking(queue: DispatchQueue = DataTransferQueue.shared.queue,
                           seconds: Double = 0.0) throws -> Self.Output? {
        var error: Error?
        var output: Self.Output?
        let semaphore = DispatchSemaphore(value: 0)
        return try queue.sync {
            _ = self
                .first()
                .delay(for: .seconds(seconds), scheduler: queue)
                .receive(on: queue)
                .subscribe(on: queue)
                .sink { completion in
                    switch completion {
                        case let .failure(e):
                            error = e
                            semaphore.signal()
                        case .finished:
                            semaphore.signal()
                    }
                } receiveValue: { value in
                    output = value
                }
            semaphore.wait()
            if let e = error {
                throw e
            }
            return output
        }
    }
    
    public func toPublisherBlocking(queue: DispatchQueue = DataTransferQueue.shared.queue,
                                    seconds: Double = 0.0) -> AnyPublisher<Self.Output, Self.Failure> {
        return self.toFutureBlocking(seconds: seconds,
                                     queue: queue).eraseToAnyPublisher()
    }
    
    public func toFutureBlocking(seconds: Double = 0.0,
                                 queue: DispatchQueue = DataTransferQueue.shared.queue) -> Future<Self.Output, Self.Failure> {
        let semaphore = DispatchSemaphore(value: 0)
        return Future { promise in
            queue.sync {
                _ = self
                    .first()
                    .delay(for: .seconds(seconds), scheduler: queue)
                    .receive(on: queue)
                    .subscribe(on: queue)
                    .sink { completion in
                        switch completion {
                            case let .failure(error):
                                promise(.failure(error))
                                semaphore.signal()
                            case .finished:
                                semaphore.signal()
                        }
                    } receiveValue: { value in
                        promise(.success(value))
                    }
                semaphore.wait()
            }
        }
    }
}
