//
//  OnboardingViewController.swift
//  Agenda
//
//  Created by Егор Бадмаев on 10.04.2022.
//

import UIKit
import SwiftUI

final class OnboardingViewController: UIViewController {
    
    private let titlesArray = [Labels.Onboarding.title1, Labels.Onboarding.title2, Labels.Onboarding.title3]
    private let descriptionsArray = [Labels.Onboarding.description1, Labels.Onboarding.description2, Labels.Onboarding.description3]
    private let imagePathsArray = ["lightbulb", "chart.bar.doc.horizontal", "chart.bar.xaxis"]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Labels.Onboarding.welcomeLabel
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.backgroundColor = .clear
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var backgroundButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(Labels.Onboarding.continueButtonLabel, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.zPosition = 1
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setContraints()
    }
}

// MARK: - Methods
private extension OnboardingViewController {
    
    func setupView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        if let locale = Locale.current.languageCode, locale == "en" {
            // Like Apple do
            let labelText = NSMutableAttributedString(string: welcomeLabel.text ?? "")
            labelText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 15, length: 6))
            welcomeLabel.attributedText = labelText
        }
        contentView.addSubview(tableView)
        
        view.addSubview(backgroundButtonView)
        backgroundButtonView.addSubview(continueButton)
    }
    
    func setContraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundButtonView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.9 - (view.frame.size.height / view.frame.size.width)),
        ])
        NSLayoutConstraint.activate([
            backgroundButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundButtonView.heightAnchor.constraint(equalToConstant: 84),
            
            continueButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    @objc func continueButtonTapped() {
        dismiss(animated: true)
        UserDefaults.standard.hasOnboarded = true
    }
}

// MARK: - UITableViewDataSource
extension OnboardingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.identifier, for: indexPath) as? OnboardingTableViewCell
        else {
            fatalError("Fatal error at creating OnboardingTableViewCell in `cellForRowAt` method")
        }
        cell.backgroundColor = .clear
        cell.iconImageView.image = UIImage(named: imagePathsArray[indexPath.section])
        cell.titleLabel.text = titlesArray[indexPath.section]
        cell.descriptionLabel.text = descriptionsArray[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
