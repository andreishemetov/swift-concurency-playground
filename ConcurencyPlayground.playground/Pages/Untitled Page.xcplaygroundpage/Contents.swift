import UIKit
import Combine
import PlaygroundSupport

var greeting = "Hello, playground"


print(greeting)

Task {
    let basicTask = Task {
        return "This is the result of the task"
    }
    print(await basicTask.value)
}

actor MyActor {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
}

actor ChickenFeeder {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
    
    func chickenStartsEating() {
        numberOfEatingChickens += 1
        notifyObservers()
    }
    
    func chickenStopsEating() {
        numberOfEatingChickens -= 1
    }
    
    nonisolated func printWhatChickensAreEating() {
            print("Chickens are eating \(food)")
        }
}

extension ChickenFeeder {
    func notifyObservers() {
        NotificationCenter.default.post(name: NSNotification.Name("chicken.started.eating"), object: numberOfEatingChickens)
    }
}

final class ActorDispatcher{
    @MainActor
    func methodWithMainActor(){
        
    }
}

Task {
    let feeder = ChickenFeeder()
    await feeder.chickenStartsEating()
    feeder.printWhatChickensAreEating()
//    print(await feeder.numberOfEatingChickens)
//    print(feeder.food)
    //feeder.chickenStopsEating()
}

final class User: Sendable {
    let name: String

    init(name: String) { self.name = name }
}



