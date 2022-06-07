//
//  AddGoalViewController.swift
//  Agenda
//
//  Created by Егор Бадмаев on 02.06.2022.
//  

import UIKit

final class AddGoalViewController: UIViewController {
    
    private let output: AddGoalViewOutput
    
    public var goalData = GoalData() {
        didSet {
            checkBarButtonEnabled()
        }
    }
    
    private lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        barButton.isEnabled = false
        return barButton
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.register(GoalTableViewCell.self, forCellReuseIdentifier: GoalTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(output: AddGoalViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Labels.Agenda.newGoal
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeThisVC))
        navigationItem.rightBarButtonItem = doneBarButton
        
        view.backgroundColor = .systemBackground
        setupViewAndConstraints()
        
        // This methods is declared in Extensions/UIKit/UIViewController.swift
        // It allows to hide keyboard when user taps in any place
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterForKeyboardNotifications()
    }
}

extension AddGoalViewController: AddGoalViewInput {
}

// MARK: - UITableView
extension AddGoalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalTableViewCell.identifier, for: indexPath) as? GoalTableViewCell
        else { return GoalTableViewCell() }
        cell.delegate = self
        cell.configure(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Helper methods
private extension AddGoalViewController {
    @objc func doneButtonTapped() {
        output.doneButtonTapped(data: goalData)
    }
    
    @objc func closeThisVC() {
        output.closeThisModule()
    }
    
    func checkBarButtonEnabled() {
        if !goalData.title.isEmpty, !goalData.current.isEmpty, !goalData.aim.isEmpty {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    func setupViewAndConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - GoalTableViewCellDelegate
extension AddGoalViewController: GoalTableViewCellDelegate {
    func updateHeightOfRow(_ cell: GoalTableViewCell, _ textView: UITextView) {
        resize(cell, in: tableView, with: textView) // Update height of UITextView based on text's number of lines
    }
}
