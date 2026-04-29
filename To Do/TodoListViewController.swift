
import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let fileCache = FileCache()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Plus")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 12
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 54
        button.layer.masksToBounds = false
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setupHierarchy()
        setupConstraits()
        
        self.title = "Мои дела"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 38, weight: .bold),
            .foregroundColor: UIColor.label
        ]

        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.backgroundColor = .systemGray6
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let task = TodoItem(text: "Покушать", importance: .high, deadline: Date(timeIntervalSince1970: 1300000000), chandgedAt: nil)
        let task2 = TodoItem(text: "Покушать2", importance: .high,deadline: nil, isComplete: true, chandgedAt: nil)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler)  in
            guard let self = self else { return }
            
            let tasks = Array(self.fileCache.items.values)
            let task = tasks[indexPath.row]
            
            self.fileCache.remove(id: task.id)
            
            self.fileCache.save(to: "Todo.json")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        let infoAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler)  in
            guard let self = self else { return }
            
            print("info")
            completionHandler(true)
        }
        infoAction.backgroundColor = .gray
        infoAction.image = UIImage(systemName: "info.circle")
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler)  in
            guard let self = self else { return }
            
            let tasks = Array(self.fileCache.items.values)
            let task = tasks[indexPath.row]
            
            let updatedTask = TodoItem(id: task.id, text: task.text, importance: task.importance, deadline: task.deadline, isComplete: !task.isComplete, createdAt: task.createdAt, chandgedAt: task.chandgedAt)

            self.fileCache.add(item: updatedTask)
            self.fileCache.save(to: "Todo.json")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        completeAction.backgroundColor = .systemGreen
        completeAction.image = UIImage(systemName: "checkmark.circle.fill")
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 54),
            addButton.heightAnchor.constraint(equalToConstant: 54)
            
        ])
    }
    
}
