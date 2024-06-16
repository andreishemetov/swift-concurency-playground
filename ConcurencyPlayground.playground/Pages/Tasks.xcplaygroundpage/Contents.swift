//: [Previous](@previous)

import Foundation

var greeting = "Hello, Tasks"

//Task {
//    await asyncPrint("Operation one")
//    Task.detached(priority: .background) {
//        // Runs asynchronously
//        await asyncPrint("Operation two")
//    }
//    await asyncPrint("Operation three")
//
//    @Sendable func asyncPrint(_ string: String) async {
//        print(string)
//    }
//}

func example_1(){
    let basicTask = Task { @MainActor in
        // Executes async
        print("BasicTask start \(Thread.current)")
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        print("BasicTask end")
        return "This is the result of the task"
    }
    
    Task {
        print("Task start \(Thread.current)")
        
        print(await basicTask.value)
        print("Task end \(Thread.current)")
    }
    
    print("Example 1 \(Thread.current)")
}

/* example_1 result
 
 Task start <NSThread: 0x600001709d80>{number = 3, name = (null)}
 Example 1 <_NSMainThread: 0x600001700000>{number = 1, name = main}
 BasicTask start <_NSMainThread: 0x600001700000>{number = 1, name = main}
 BasicTask end
 This is the result of the task
 Task end <NSThread: 0x60000171c000>{number = 8, name = (null)}
 */
 
//example_1()


struct Data {
    var data1: [String]
    var data2: [String]
    var data3: [String]
}

class DataLoader{
    
    func loadDataByQueue() async -> [[String]] {
        print("loadDataByQueue start \(Thread.current)")
        defer {
            print("loadDataByQueue end")
        }
        let d1 = await loadData1()
        let d2 = await loadData2()
        let d3 = await loadData3()
        
        return [d1, d2, d3]
    }
    
    func loadDataBySeparate() async -> Data {
        print("loadDataBySeparate start \(Thread.current)")
        defer {
            print("loadDataBySeparate end")
        }
        async let d1 = loadData1()
        async let d2 = loadData2()
        async let d3 = loadData3()
        
        return await Data(data1: d1, data2: d2, data3: d3)
    }
    
    func loadData1() async -> [String] {
        let t = Task {
            print("loadData1 start \(Thread.current)")
            defer {
                print("loadData1 end")
            }
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            
            return ["Data11", "Data12", "Data13"]
        }
        return await t.value
    }
    
    func loadData2() async -> [String] {
        let t = Task {
            print("loadData2 start \(Thread.current)")
            defer {
                print("loadData2 end")
            }
            try! await Task.sleep(nanoseconds: 2_000_000_000)
            
            return ["Data21", "Data22", "Data23"]
        }
        return await t.value
    }
    
    func loadData3() async -> [String] {
        let t = Task {
            print("loadData3 start \(Thread.current)")
            defer {
                print("loadData3 end")
            }
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            
            return ["Data31", "Data32", "Data33"]
        }
        return await t.value
        
    }
    
}

/* example_2 result
 
 loadDataByQueue start <NSThread: 0x600001701fc0>{number = 6, name = (null)}
 loadData1 start <NSThread: 0x600001706900>{number = 2, name = (null)}
 loadData1 end
 loadData2 start <NSThread: 0x600001700540>{number = 7, name = (null)}
 loadData2 end
 loadData3 start <NSThread: 0x600001701fc0>{number = 6, name = (null)}
 loadData3 end
 loadDataByQueue end
 
 loadDataBySeparate start <NSThread: 0x60000171c180>{number = 6, name = (null)}
 loadData2 start <NSThread: 0x60000170ce80>{number = 4, name = (null)}
 loadData3 start <NSThread: 0x600001710140>{number = 9, name = (null)}
 loadData1 start <NSThread: 0x60000170afc0>{number = 2, name = (null)}
 loadData1 end
 loadData3 end
 loadData2 end
 loadDataBySeparate end
 
 
 */

func example_2() async{
    let dl = DataLoader()
//    await dl.loadDataByQueue()
    await dl.loadDataBySeparate()
}


Task { @MainActor in
    await example_2()
}



//: [Next](@next)


