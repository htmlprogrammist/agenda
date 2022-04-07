//
//  SummaryViewController.swift
//  Agenda
//
//  Created by Егор Бадмаев on 10.12.2021.
//

import UIKit

final class SummaryViewController: UIViewController {
    
    private var coreDataManager: CoreDataManagerProtocol
//    private lazy var months = coreDataManager.fetchMonths()
    private lazy var fetchedResultsController = coreDataManager.monthsFetchedResultsController
    private var months: [Month]! // set only after the first fetch, used only after the setting
    
    private let imagePaths = ["number", "checkmark.square", "xmark.square", "list.bullet"]
    private let titleLabelsText = ["Average number of completed goals", "Completed goals", "Uncompleted goals", "All goals"]
    private let tintColors: [UIColor] = [.systemTeal, .systemGreen, .systemRed, .systemOrange]
    private let measureLabelsText = ["goals", "goals", "goals", "goals"] // such a bad thing when they are repeating
//    private var numbers = [3.2, 4, 13, 17]
    private var numbers = [0.0, 0.0, 0.0, 0.0]
    
    /// 1. Average number of completed goals
    /// 2. Completed goals
    /// 3. Uncompleted goals
    /// 4. All goals
    /// 4. Months with completed goals?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.backgroundColor = .white
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Summary"
        
        setupView()
        setConstraints()
        
        do {
            try fetchedResultsController.performFetch()
            coreDataManager.delegate = self
        } catch {
            alertForError(title: "Oops!", message: "We've got unexpected error while loading statistics. Please, restart the application")
        }
        
        if let months = fetchedResultsController.fetchedObjects {
            self.months = months
            countGoals(months: months)
        }
    }
    
    private func setupView() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func countGoals(months: [Month]) {
        var completedGoalsCounter = 0
        var uncompletedGoalsCounter = 0
        var allGoalsCounter = 0
        for month in months {
            guard let goals = month.goals?.array as? [Goal] else { return }
            for goal in goals {
                if goal.current >= goal.aim {
                    completedGoalsCounter += 1
                } else {
                    uncompletedGoalsCounter += 1
                }
                allGoalsCounter += 1
            }
        }
        let formattedNumber = Double(round(10 * Double(completedGoalsCounter) / Double(allGoalsCounter)) / 10)
        numbers[0] = formattedNumber
        numbers[1] = Double(completedGoalsCounter)
        numbers[2] = Double(uncompletedGoalsCounter)
        numbers[3] = Double(allGoalsCounter)
    }
}

// MARK: UITableView
extension SummaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as? SummaryTableViewCell
        else {
            fatalError("Could not create SummaryTableViewCell")
        }
        let summary = Summary(iconImagePath: imagePaths[indexPath.section], title: titleLabelsText[indexPath.section], tintColor: tintColors[indexPath.section], number: numbers[indexPath.section], measure: measureLabelsText[indexPath.section])
        cell.configure(data: summary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension SummaryViewController: CoreDataManagerDelegate {
    func reloadTableView() {
        countGoals(months: months)
        tableView.reloadData()
    }
}
