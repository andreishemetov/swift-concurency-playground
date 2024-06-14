//: [Previous](@previous)

import Foundation
import Combine
import PlaygroundSupport

var greeting = "Hello, playground 2"

enum CustomError: Error {
    case delayError
}

public class Student {
    var id: Int
    var processingTime: Int

    init(id: Int, processingTime: Int) {
        self.id = id
        self.processingTime = processingTime
    }
}

var students = [
    Student(id: 1, processingTime: 2),
    Student(id: 2, processingTime: 5),
    Student(id: 3, processingTime: 4),
    Student(id: 4, processingTime: 1),
]

private func delayAfter(delay: Int) async throws -> Int {
    if delay % 2 == 0 {
        throw CustomError.delayError
    }

    try await Task.sleep(
        until: .now + .seconds(delay),
        clock: .suspending
    )

    return delay
}

func getProcessingTime(students: [Student]) async throws {
    
    await withTaskGroup(of: Void.self, body: { group in
        for student in students {
            group.addTask {
                do {
                    let processingTime = try await delayAfter(delay: student.processingTime)
                    print("processing Time \(processingTime)  id \(student.id)")
                } catch {
                    print("error   id \(student.id)")
                }
            }
        }
    })
}

func getProcessingTimeWithReturn(students: [Student]) async throws -> [Int: Int] {
    
    var processingTimeList: [Int: Int] = [:]

    try await withThrowingTaskGroup(of: (Int, Int).self, body: { group in

        for student in students {
            group.addTask {
                do {
                    let processingTime = try await delayAfter(delay: student.processingTime)
                    print("processing Time \(processingTime)  id \(student.id)")
                    return (student.id, processingTime)
                }catch{
                    print("error  id \(student.id)")
                    return (student.id, -1)
                }
            }
        }

        for try await (id, time) in group {
            processingTimeList[id] = time
        }

    })

    return processingTimeList
}

Task {
    let startTime = DispatchTime.now()

//    try await getProcessingTime(students: students)

    let processingTimesWithId =  try await getProcessingTimeWithReturn(students: students)
    print(processingTimesWithId)
    
    
    let endTime = DispatchTime.now()
    let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000000
    print("ElapsedTime \(elapsedTime)")
}

//    PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
