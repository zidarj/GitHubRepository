//
//  GHMainViewController.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

final class GHMainViewController: GHViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: GHMainViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupUI()
    }
    
    private func setupUI() {
        title = "Repositories"
        viewModel = GHMainViewModel(delegate: self)
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        self.hideKeyboardWhenTappedAround()
    }
    
    private func registerNib() {
        tableView.registerNib(GHRepositoryTableViewCell.self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 500 {
            viewModel.searchRepositories(requestType: .pagination)
        }
    }
}
extension GHMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GHRepositoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let repository = viewModel.repositories[indexPath.row]
        cell.config(repository: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        GHMainControllerHelper.openRepositoryDetails(from: self, repository: repository)
    }
}
extension GHMainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { viewModel.resetSearch(); return }
        viewModel.params.searchText = searchText
        viewModel.searchRepositories()
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { viewModel.resetSearch(); return }
        viewModel.params.searchText = searchText
        viewModel.searchRepositories()
        view.endEditing(true)
    }
}
extension GHMainViewController: GHNetworkRequestableDelegate {
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
