
import Foundation

enum Importance: String {
    
    case low = "Неважная"
    case normal = "Обычная"
    case high = "Важная"
    
}

struct TodoItem {
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isComplete: Bool
    let createdAt: Date
    let chandgedAt: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date?, isComplete: Bool = false, createdAt: Date = Date(), chandgedAt: Date?) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isComplete = isComplete
        self.createdAt = createdAt
        self.chandgedAt = chandgedAt
    }
    
}

extension TodoItem {
    
    var json: Any {
        var dict = [String: Any]()
        dict["id"] = id
        dict["text"] = text
        dict["isComplete"] = isComplete
        dict["createdAt"] = createdAt.timeIntervalSince1970
        
        if importance != .normal {
            dict["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let chandgedAt = chandgedAt {
            dict["changedAt"] = chandgedAt.timeIntervalSince1970
        }
            
        return dict
    }
    
    static func parse(json: Any) -> TodoItem? {
        
        guard let dict = json as? [String: Any] else { return nil }
        
        guard let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isComplete = dict["isComplete"] as? Bool,
              let createdAtTime = dict["createdAt"] as? Double
        else { return nil }
        
        let createdAt = Date(timeIntervalSince1970: createdAtTime)
        
        let importanceString = dict["importance"] as? String
        let importance = Importance(rawValue: importanceString ?? "") ?? .normal
        
        var deadline: Date?
        if let deadlineDate = dict["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineDate)
        }
        
        var chandgedAt: Date?
        if let changedAtDate = dict["changedAt"] as? Double {
            chandgedAt = Date(timeIntervalSince1970: changedAtDate)
        }
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isComplete: isComplete, createdAt: createdAt, chandgedAt: chandgedAt)
        
    }
    
}
