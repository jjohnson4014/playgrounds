
class Event {
    var listeners: [((sender:AnyObject)->())] = []
    func trigger(sender:AnyObject) {
        for action in listeners {
            action(sender: sender)
        }
    }
}

infix operator += {}
func += (event:Event, action:(sender:AnyObject)->()) {
    event.listeners.append(action)
}

class Test {
    let aValueChanged = Event()
    
    var aValue:String? {
        didSet(oldValue) {
            aValueChanged.trigger(self)
        }
    }
}

func someMethod(sender:AnyObject) {
    if let test = sender as? Test {
        println("new Test.aValue is \(test.aValue!)")
    }
}

let firstTest = Test()

firstTest.aValueChanged += someMethod
firstTest.aValueChanged.listeners.count
firstTest.aValue = "first new value"
firstTest.aValue = "second new value"

class AnotherTest {
    let myTest = Test()
    
    func aReaction(sender:AnyObject) -> () {
        if let newValue = myTest.aValue {
            println("anotherTest changed the value to \(newValue)")
        }
    }
    
    init() {
        myTest.aValueChanged += aReaction
        myTest.aValue = "wow"
    }
}

let secondTest = AnotherTest()
