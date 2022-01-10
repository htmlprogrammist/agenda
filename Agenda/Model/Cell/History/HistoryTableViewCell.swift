//
//  HistoryTableViewCell.swift
//  Agenda
//
//  Created by Егор Бадмаев on 18.12.2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    let monthDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let detailsSubtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    // надо ли писать статистику? По количеству достигнтутых и поставленных целей?
    // "Цели: 3/5" (серым цветом)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryTableViewCell {
    
    func setupView() {
        let getSomeInfoFromDataBase1 = 3
        let getSomeInfoFromDataBase2 = 5
        
        detailsSubtitle.text = "Goals: \(getSomeInfoFromDataBase1)/\(getSomeInfoFromDataBase2)"
        
        cellStackView.addArrangedSubview(monthDateLabel)
        cellStackView.addArrangedSubview(detailsSubtitle)
    }
    
    func setContraints() {
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
