//
//  LeftMenuViewController.swift
//  Mail
//
//  Created by Andrii on 6/21/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit

protocol LeftMenuViewControllerDelegate: class {
    func didSelectRailwayCrossing(_ railwayCrossing: RailwayCrossing)
}

class LeftMenuViewController: UIViewController {
    
    weak var delegate: LeftMenuViewControllerDelegate?
            
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 80, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeftMenuTableViewCell.self, forCellReuseIdentifier: LeftMenuTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private var expertsHeaderView: LeftMenuHeaderView!
    private var questionsHeaderView: LeftMenuHeaderView!
    
    private var dataSource: [RailwayCrossing]
    
    init() {
//        self.dataSource = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension LeftMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTableViewCell.reuseIdentifier) as! LeftMenuTableViewCell
        cell.setup(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sideMenuController?.hideLeftViewAnimated()
        
        let item = dataSource[indexPath.row]
        
        delegate?.didSelectRailwayCrossing(item)

//        let section = model.sections[indexPath.section]
//        let category = model.sections[indexPath.section].items[indexPath.row]
//        switch section.type {
//        case .experts:
//            let expertsViewController = ExpertsViewController(category: category)
//            sideMenuController?.rootViewController = expertsViewController
//        case .questions:
//            let questionsViewController = TopicsViewController(category: category)
//            sideMenuController?.rootViewController = questionsViewController
//        default:
//            return
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
