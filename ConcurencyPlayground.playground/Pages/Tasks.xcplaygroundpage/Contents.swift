//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

Task {
    await asyncPrint("Operation one")
    Task.detached(priority: .background) {
        // Runs asynchronously
        await asyncPrint("Operation two")
    }
    await asyncPrint("Operation three")

    @Sendable func asyncPrint(_ string: String) async {
        print(string)
    }
}



//: [Next](@next)


