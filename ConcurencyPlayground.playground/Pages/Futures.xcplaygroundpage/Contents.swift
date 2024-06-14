import UIKit
import Combine
import Foundation
import PlaygroundSupport

var greeting = "Hello, playground"

func createFuture() -> Future<Int, Never> {
    return Future { promise in
        promise(.success(42))
    }
}

createFuture().sink(receiveValue: { value in
    print(value)
    //    CFRunLoopStop(CFRunLoopGetMain())
    PlaygroundPage.current.finishExecution()
})

//
//CFRunLoopRun()

func fetchImages( completion: @escaping (Result<[String], Error>) -> Void) {
    Task {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        completion(.success(["image1", "image2", "image3"]))
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true



