//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var greeting = "Hello, GCD"

PlaygroundPage.current.needsIndefiniteExecution = true

/* Example 1
var counter = 1
DispatchQueue.main.async{
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

for i in 4...6 {
    counter = i
    print("\(counter)")
}

DispatchQueue.main.async{
    for i in 7...9 {
        counter = i
        print("\(counter)")
    }
}
 */

/* Example 2
DispatchQueue.global(qos: .background).async{
    for i in 11...21 {
        print("\(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async{
    for i in 0...10 {
        print("\(i)")
    }
}
 */

//* Example 3
//let a = DispatchQueue(label: "A")
//let b = DispatchQueue(label: "B", attributes: .concurrent)

//a.async {
//    for i in 0...5 {
//        print("\(i)")
//    }
//}
//
//a.async {
//    for i in 6...10 {
//        print("\(i)")
//    }
//}

//b.async {
//    for i in 0...99 {
//        print("\(i)")
//    }
//}
//
//b.async {
//    for i in 101...199 {
//        print("\(i)")
//    }
//}

final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var readMessage: String? {
        
        return queue.sync {
            guard let m = messages.last else { return nil}
            print("readMessage \(m)")
            return m
        }
    }
    
    var readMessages: [String] {
        
        return queue.sync {
            print("readMessages \(messages)")
            return messages
        }
    }

    func postMessage(_ newMessage: String) {
        queue.async(flags: .barrier) { [weak self] in
            print("postMessage \(newMessage)")
            self?.messages.append(newMessage)
        }
    }
}

let messenger = Messenger()


let myConcQueue1 = DispatchQueue(label: "com.kraken.barrier_1", attributes: .concurrent)
let myConcQueue2 = DispatchQueue(label: "com.kraken.barrier_2", attributes: .concurrent)
let myConcQueue3 = DispatchQueue(label: "com.kraken.barrier_2", attributes: .concurrent)
 
for i in 1...5 {
    messenger.postMessage("Message_Main \(i)")
    
    myConcQueue1.async() {
        messenger.postMessage("Message_Q1 \(i)")
        }
   
    myConcQueue3.async() {
        let m = messenger.readMessages
//        print(m)
        }
 
   
}
 
 

//: [Next](@next)
