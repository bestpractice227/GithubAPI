//
//  SearchViewController.swift
//  GithubAPI
//
//  Created by Van Le on 9/18/19.
//  Copyright © 2019 ITPS. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationHeightConstraint: NSLayoutConstraint!
    
    var users: Users?

    var itemPerPage: Int = 10
    var currentPage: Int = 1
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tableView.estimatedRowHeight = 44
        tableView.keyboardDismissMode = .onDrag
        if Utils.isIphoneX() {
            navigationHeightConstraint.constant += 24
        }
    }
    
    @objc func textFieldDidChange() {

        if self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        self.currentPage = 1
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.search(self.textField.text ?? "", self.currentPage)
        })
    }
    
    func loadMore() {
        currentPage += 1
        
        requestSearch(self.textField.text ?? "", self.currentPage) { (result) in
            self.users?.items.append(contentsOf: result.items)
            self.tableView.reloadData()
        }
    }
    
    func search(_ user: String, _ page: Int) {
        requestSearch(user, page) { (result) in
            self.users = result
            self.tableView.reloadData()
        }
        
    }
    // MARK: API
    func requestSearch(_ user: String, _ page: Int, _ completionHander: @escaping ((_ users: Users) -> Void)) {
        Alamofire.request("https://api.github.com/search/users?q=\(user)&page=\(page)&per_page=\(self.itemPerPage)").responseObject { (response: DataResponse<Users>) in
            guard let users = response.result.value else { return}
            
            print("q= ", user)
            print("page= ", page)
            print("result=", response.result.value?.totalCount)
            
            completionHander(users)
        }
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users else { return 0 }
        return users.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else { return UITableViewCell() }
        guard let users = users else { return UITableViewCell() }
        cell.loadData(item: users.items[indexPath.row])
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let users = users else { return }
        if indexPath.row == users.items.count-1 {
            if self.currentPage <= (users.totalCount / itemPerPage) {
                self.loadMore()
            }
            
        }
    }
}

