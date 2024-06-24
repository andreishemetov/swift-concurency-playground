//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var greeting = "Hello, ReadersAndWriters"

PlaygroundPage.current.needsIndefiniteExecution = true


final class FileLoader {
    
    private let semaphore = Semaphore()
    
    func load(file: String) async {
        Task{
            semaphore.wait()
            defer { semaphore.signal() }
            print("load start: \(file)")
            try! await Task.sleep(for: .seconds(1))
            print("load end: \(file)")
        }
    }
    
    
    
}

struct Semaphore: Sendable {
    private let semaphore = DispatchSemaphore(value: 5)
    
    init() {}
    
    func wait(){
        semaphore.wait();
    }
    
    func signal(){
        semaphore.signal();
    }
}

func testFileLoader() {
    print("Hello")
        let loader = FileLoader();
        for i in 1...32 {
            Task.detached{
                await loader.load(file: "File \(i)")
            }
        }
}

testFileLoader()

//: [Next](@next)
