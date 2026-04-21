import Foundation
import UIKit

class TodoTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let checkBox: UIImageView = {
        let check = UIImageView()
        check.translatesAutoresizingMaskIntoConstraints = false
        return check
    }()
    
    private let importance: UIImageView = {
        let importance = UIImageView()
        importance.translatesAutoresizingMaskIntoConstraints = false
        return importance
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let calendarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "Calendar")
        return imageView
    }()
    
    private let verticalLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private let deadlineHorizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private let cellHorizontallStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMMM"
        df.locale = Locale(identifier: "ru_RU")
        return df
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        setupHierarchy()
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: TodoItem) {
        titleLabel.text = item.text
        
        switch item.importance {
        case .low:
            importance.image = UIImage(named: "priority_low")
            importance.isHidden = false
        case .normal:
            importance.isHidden = true
        case .high:
            importance.image = UIImage(named: "priority_high")
            importance.isHidden = false
        }
        
        if item.isComplete {
            checkBox.image = UIImage(systemName: "is_done")
            
            let attributeString = NSMutableAttributedString(string: item.text)
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .gray
        } else if item.importance == .high {
            checkBox.image = UIImage(named: "high_priority")
            titleLabel.attributedText = nil
            titleLabel.text = item.text
            titleLabel.textColor = .label
        } else {
            checkBox.image = UIImage(named: "in_progress")
            titleLabel.attributedText = nil
            titleLabel.text = item.text
            titleLabel.textColor = .label
        }
        
        if let deadline = item.deadline {
            deadlineHorizontalStack.isHidden = false
            deadlineLabel.text = dateFormatter.string(from: deadline)
            
        } else {
            deadlineHorizontalStack.isHidden = true
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(cellHorizontallStack)
        cellHorizontallStack.addArrangedSubview(checkBox)
        cellHorizontallStack.addArrangedSubview(importance)
        cellHorizontallStack.addArrangedSubview(verticalLabelStack)
        verticalLabelStack.addArrangedSubview(titleLabel)
        verticalLabelStack.addArrangedSubview(deadlineHorizontalStack)
        deadlineHorizontalStack.addArrangedSubview(calendarImage)
        deadlineHorizontalStack.addArrangedSubview(deadlineLabel)
        
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            cellHorizontallStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellHorizontallStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellHorizontallStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellHorizontallStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            importance.widthAnchor.constraint(equalToConstant: 16),
            importance.heightAnchor.constraint(equalToConstant: 20),
            
            calendarImage.widthAnchor.constraint(equalToConstant: 16),
            calendarImage.heightAnchor.constraint(equalToConstant: 16),
            /*
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            importance.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            importance.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 16),
            
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: importance.trailingAnchor, constant: 3),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            */
            
        ])
    }
}
