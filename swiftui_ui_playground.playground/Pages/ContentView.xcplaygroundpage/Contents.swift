//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct TaskListContainer: View {
    @EnvironmentObject var taskStore: TaskStore

    var body: some View {
        EquatableView(
            TaskListView(
                tasks: taskStore.tasks,
                categories: taskStore.categories
            )
        ).onAppear(perform: taskStore.load)
    }
}


struct ContentView: View {
    @State private var counter = 0
    @State private var toggleState = false

    var body: some View {
        VStack {
            Text("Counter: \(counter)")
            
            Button("Increment") {
                counter += 1
            }
            .padding()
            
            Text("Toggle State: \(toggleState.description)")
                .equatable(toggleState) // Use EquatableView with specific property
            
            Toggle("Toggle", isOn: $toggleState)
                .padding()
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())

//: [Next](@next)
