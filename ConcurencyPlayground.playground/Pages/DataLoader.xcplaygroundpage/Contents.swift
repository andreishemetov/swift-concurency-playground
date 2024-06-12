//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


var greeting = "DataLoader playground"

func concurrentQueues(){
    let myQueue = DispatchQueue(label: "com.multithreading.concurr", qos: .utility, attributes: .concurrent)
    myQueue.async {
        for i in 0..<10 {
            print("1")
        }
    }
    myQueue.async {
        for j in 0..<10 {
            print("2")
        }
    }
}

//: [Next](@next)
