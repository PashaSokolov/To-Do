import Foundation

class FileCache {
    
    private(set) var items: [String: TodoItem] = [:]
    
    func add(item: TodoItem) {
        items[item.id] = item
    }
    
    func remove(id: String) {
        items.removeValue(forKey: id)
    }
    
    func save(to file: String) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(file)
        var jsonArray: [Any] = []
        
        for item in items.values {
            let itemJson = item.json
            jsonArray.append(itemJson)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileURL)
        } catch {
            print("Ошибка сохранения \(error)")
        }
        
    }
    
    func load(from file: String){
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(file)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonObject as? [Any] else { return }
            
            items.removeAll()
            
            for itemJson in jsonArray {
                if let task = TodoItem.parse(json: itemJson) {
                    self.add(item: task)
                }
            }
        } catch {
            print("Не удалось загрузить файл \(error)")
        }
    }
    
}
