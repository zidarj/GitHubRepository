//
//  GHRepositoryDetailsViewController.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

final class GHRepositoryDetailsViewController: GHViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: GHRepositoryDetailsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNib()
    }
    
    private func setupUI() {
        title = "Repository details"
    }
    
    private func registerNib() {
        tableView.registerNib(GHTitleTableViewCell.self)
        tableView.registerNib(GHDescriptionTableViewCell.self)
    }
    
    final func config(repository: GHRepository) {
        viewModel = GHRepositoryDetailsViewModel(with: repository, delegate: self)
    }
}
extension GHRepositoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.structure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.structure[indexPath.row] {
        case .repositoryName:
            let cell: GHTitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let config = GHTitleTableViewCell.Configuration(title: viewModel.repository.name, alignment: .center)
            cell.config(with: config)
            return cell
            
        case .lastUpdateTime:
            let cell: GHTitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let updated = viewModel.repository.pushedAt.stringToDate.dateToString
            let config = GHTitleTableViewCell.Configuration(title: "Updated on " + updated,
                                                            font: UIFont.italicSystemFont(ofSize: 15),
                                                            alignment: .right)
            cell.config(with: config)
            return cell
            
        case .ownerName:
            let cell: GHTitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let name = viewModel.owner?.name {
                let config = GHTitleTableViewCell.Configuration(title: name,
                                                                font: UIFont.systemFont(ofSize: 17),
                                                                alignment: .left,
                                                                icon: UIImage(named: "user"))
                cell.config(with: config)
            }
            return cell
            
        case .description:
            let cell: GHDescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(with: "Description", description: viewModel.repository.description)
            return cell
            
        }
    }
}
extension GHRepositoryDetailsViewController: GHNetworkRequestableDelegate {
    func didPerformRequest(_ req: GHDataRequest?) {
        self.showProgress()
    }
    
    func didReceiveError(_ error: Error) {
        self.displayError(error)
    }
    
    func didFetch() {
        self.dismissProgress()
        tableView.reloadData()
    }
}
