
import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Задача №\(indexPath.row)"
            
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        setupHierarchy()
        setupConstraits()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
