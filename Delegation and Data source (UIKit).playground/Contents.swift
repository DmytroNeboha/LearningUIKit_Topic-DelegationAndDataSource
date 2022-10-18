
import Foundation


// Книга Усова, вторая


// протоколы:
protocol MessageProtocol {
    var text: String? { get set }
    var image: Data? { get set }
    var audio: Data? { get set }
    var video: Data? { get set }
    var sendDate: Date { get set }
    var senderID: UInt { get set }
}

protocol StatisticDelegate: AnyObject {
    func handle(message: MessageProtocol)
}

protocol MessengerProtocol {
    // ...
    // делегат для загрузки сообщения
    var dataSource: MessengerDataSourceProtocol? { get set }
    var messages: [MessageProtocol] { get set }
    var statisticDelegate: StatisticDelegate? { get set }
    
    init()
    
    mutating func receive(message: MessageProtocol)
    mutating func send(message: MessageProtocol)
}


// Шаблоны "Источник данных"
protocol MessengerDataSourceProtocol: AnyObject {   // * class
func getMessages() -> [MessageProtocol]
}




// типы данных:
struct Message: MessageProtocol {
    var text: String?
    var image: Data?
    var audio: Data?
    var video: Data?
    var sendDate: Date
    var senderID: UInt
}

class StatisticManager: StatisticDelegate {
    func handle(message: MessageProtocol) {
        // ...
        //  обработка сообщения
        // ...
        print("Обработка сообщения от User # \(message.senderID) завершена")
    }
}

class Messenger: MessengerProtocol {
    weak var dataSource: MessengerDataSourceProtocol? {
        didSet {
            if let source = dataSource {
                messages = source.getMessages()
            }
        }
    }
    var messages: [MessageProtocol]
    weak var statisticDelegate: StatisticDelegate?
    
    required init() {
        messages = []
    }
    
    
    func receive(message: MessageProtocol) {
        statisticDelegate?.handle(message: message)
        messages.append(message)
        // ...
        // прием сообщения
        // ...
    }
    
    func send(message: MessageProtocol) {
        statisticDelegate?.handle(message: message)
        messages.append(message)
        // ...
        // отправка сообщения
        // ...
    }
}

//var messenger = Messenger()
//messenger.statisticDelegate = StatisticManager()
//messenger.send(message: Message(text: "Привет!", sendDate: Date(), senderID: 1))


// аналог кода выше:
extension Messenger: StatisticDelegate {
    func handle(message: MessageProtocol) {
        // ...
        // обработка сообщения
        // ...
        print("Обработка сообщения от User # \(message.senderID) завершена 2")
    }
}

var messenger = Messenger()
messenger.statisticDelegate = messenger.self



// реализуем источник данных
extension Messenger: MessengerDataSourceProtocol {
    func getMessages() -> [MessageProtocol] {
        return [Message(text: "Как дела?", sendDate: Date(), senderID: 2)]
    }
}

        
// Работа с памятью



messenger.send(message: Message(text: "Привет!", sendDate: Date(), senderID: 1))
messenger.messages.count
(messenger.statisticDelegate as! Messenger).messages.count



// 1. Для того чтобы избежать утечек памяти, ссылка в свойстве statisticDelegate должна быть weak
// 2. Протокол StatisticDelegate необходимо пеметить как class или AnyObject
// 3. В реализации класса Messenger не должно использоваться mutating



var mesenger2 = Messenger()
mesenger2.dataSource = mesenger2.self
mesenger2.messages.count
