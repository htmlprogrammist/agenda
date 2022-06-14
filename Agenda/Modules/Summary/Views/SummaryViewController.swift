//
//  SummaryViewController.swift
//  Agenda
//
//  Created by Егор Бадмаев on 03.06.2022.
//  

import UIKit

final class SummaryViewController: UIViewController {
    
    private let output: SummaryViewOutput
    // TODO: rewrite this comment
    /// Indexes of `Summary.summaries` - instances of `Summary` to display data in cells. User selects the data he needs and then we add/remove these indexes.
    private var cells: [SummaryCell] = [.percentOfSetGoals, .completedGoals, .uncompletedGoals, .allGoals]
    private var summaries: [Summary] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.allowsSelection = false
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(output: SummaryViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.backgroundColor = .systemBackground
        title = Labels.Summary.title
        
        output.fetchData()
        setupViewAndConstraints()
    }
}

extension SummaryViewController: SummaryViewInput {
    func setData(summaries: [Summary]) {
        self.summaries = summaries
        
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    func showAlert(title: String, message: String) {
        alertForError(title: title, message: message)
    }
}

private extension SummaryViewController {
    func setupViewAndConstraints() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableView
extension SummaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        summaries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as? SummaryTableViewCell
        else { return SummaryTableViewCell() }
        cell.configure(data: summaries[cells[indexPath.section].rawValue])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        " " // for correct displaying (table view gets from the top too much)
    }
}

// MARK: - CoreDataManagerDelegate
extension SummaryViewController: CoreDataManagerDelegate {
    func updateViewModel() {
        output.fetchData()
    }
}
