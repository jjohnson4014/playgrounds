class Event<T> {
    var listeners: [((sender:T)->())] = []
    func trigger(sender:T) {
        for action in listeners {
            action(sender: sender)
        }
    }
}

func +=<T>(event:Event<T>, action:(sender:T)->()) {
    event.listeners.append(action)
}

class Test {
    let aValueChanged = Event<Test>()
    
    var aValue:String? {
        didSet(oldValue) {
            aValueChanged.trigger(self)
        }
    }
}

func someMethod(sender:Test) {
    if let newValue = sender.aValue {
        println("new Test.aValue is \(newValue)")
    }
}

let firstTest = Test()
firstTest.aValueChanged += someMethod
firstTest.aValue = "first value"

class ContainerTest {
    let myTest = Test()
    
    func aReaction(sender:Test) -> () {
        if let newValue = myTest.aValue {
            println("containerTest changed the value to \(newValue)")
        }
    }
    
    init() {
        myTest.aValueChanged += aReaction
        myTest.aValueChanged += {(sender:Test) in println("closure logging")}
        myTest.aValue = "wow"
    }
}

let secondTest = ContainerTest()

//TODO: need to solve object lifetime issues - need to figure out how to remove anonymous closures to avoid inadvertant memory leaks