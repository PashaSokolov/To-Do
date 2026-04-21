
import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let fileCache = FileCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        setupHierarchy()
        setupConstraits()

        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let task = TodoItem(text: "Покушать", importance: .high, deadline: Date(timeIntervalSince1970: 1300000000), chandgedAt: nil)
        let task2 = TodoItem(text: "Покушать2", importance: .high, deadline: Date(timeIntervalSince1970: 1300000000), isComplete: true, chandgedAt: nil)
        fileCache.add(item: task)
        fileCache.add(item: task2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        let tasks = Array(fileCache.items.values)
        let task = tasks[indexPath.row]
        
        cell.configure(with: task)
            
        return cell
    }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
}
