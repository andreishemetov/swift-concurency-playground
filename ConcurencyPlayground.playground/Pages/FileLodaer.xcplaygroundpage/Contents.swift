//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var greeting = "Hello, ReadersAndWriters"

PlaygroundPage.current.needsIndefiniteExecution = true


final class FileLoader {
    
    private let semaphore = Semaphore()
    
    func load(file: String) async {
        Task(priority: .background){
            semaphore.wait()
            defer { semaphore.signal() }
            let th = "\(Thread.current) threadPriority \(Thread.threadPriority())  taskPriority \(Task.currentPriority)"
            print("\(file) \(th)")
            print("load start: \(file)")
            Thread.sleep(forTimeInterval: 4)
//            try! await Task.sleep(nanoseconds: 1_000_000_000)
            print("load end: \(file)")
        }
    }
}

/* Если использовать try! await Task.sleep(nanoseconds: 1_000_000_000)

В этом случае Task.sleep не может запуститься тк он должен отработать в этом же потоке который сейчас в критической секции коей является наща функция, а наша функция также не может выполниться полностью тк не может отработать Task.sleep
 
File 1 <NSThread: 0x600001718100>{number = 2, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
load start: File 1
File 2 <NSThread: 0x600001705f00>{number = 8, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
load start: File 2
File 3 <NSThread: 0x600001714240>{number = 9, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
load start: File 3
File 4 <NSThread: 0x600001708880>{number = 10, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
File 5 <NSThread: 0x600001705f00>{number = 8, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
load start: File 4
load start: File 5
 */

/* Если использовать Thread.sleep(forTimeInterval: 4)

В этом случае мы получаем нормально работающий семафор на 5 одновременных работаюших операций без блокировки
 
 File 1 <NSThread: 0x600001718000>{number = 4, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 1
 File 3 <NSThread: 0x600001706700>{number = 6, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 3
 File 6 <NSThread: 0x600001718340>{number = 11, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 6
 File 5 <NSThread: 0x6000017147c0>{number = 9, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 5
 File 2 <NSThread: 0x600001718380>{number = 10, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 2
 load end: File 1
 File 4 <NSThread: 0x60000171c840>{number = 13, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 4
 load end: File 3
 File 7 <NSThread: 0x600001710a80>{number = 14, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 7
 load end: File 6
 File 8 <NSThread: 0x600001724840>{number = 12, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 8
 load end: File 2
 load end: File 5
 File 10 <NSThread: 0x600001706700>{number = 6, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 10
 File 9 <NSThread: 0x600001718000>{number = 4, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 9
 load end: File 8
 File 11 <NSThread: 0x600001718340>{number = 11, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 11
 load end: File 4
 File 12 <NSThread: 0x6000017147c0>{number = 9, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 12
 load end: File 7
 File 13 <NSThread: 0x600001718380>{number = 10, name = (null)} threadPriority 0.5  taskPriority TaskPriority.background
 load start: File 13
 load end: File 9
 load end: File 10
 load end: File 11
 load end: File 12
 load end: File 13
 */

struct Semaphore: Sendable {
    private let semaphore = DispatchSemaphore(value:5)
    
    init() {}
    
    func wait(){
        semaphore.wait();
    }
    
    func signal(){
        semaphore.signal();
    }
}

func testFileLoader() {
        let loader = FileLoader();
        for i in 1...13 {
            Task.detached{
                await loader.load(file: "File \(i)")
            }
        }
}

testFileLoader()

//: [Next](@next)

/*
 Thread.sleep() vs Task.sleep()
 Let’s just look at the old and new sleep APIs:

 Thread.sleep() is the old API that blocks a thread for the given amount of seconds — it doesn’t load the CPU, the core just idles. Edit: Turns out the core doesn’t idle but DispatchQueue.concurrentPerform creates only as many threads as there are cores so even if the blocked treads don’t do anything it doesn’t create more threads to do more work during this time.

 Task.sleep() is the new async API that does “sleep”. It suspends the current Task instead of blocking the thread — that means the CPU core is free to do something else for the duration of the sleep.

 Or to put them side by side:

 Thread.sleep()                                 Task.sleep()
 Blocks the thread                              Suspends and lets other tasks run
 Slow switching of threads on same core         Quickly switching via function calls to a continuation
 Rigid, cannot be cancelled                     Can be cancelled while suspended
 Code resumes on the same thread                Could resume on another thread, threads don’t matter
 */
