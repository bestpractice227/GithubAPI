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
    
    var users: [User] = []
    var timer: Timer?
    
    var itemPerPage: Int = 10
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tableView.estimatedRowHeight = 44
    }
    
    @objc func textFieldDidChange() {
        if self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.search(self.textField.text ?? "", self.currentPage)
        })
    }
    
    func loadMore() {
        currentPage += 1
        requestSearch(self.textField.text ?? "", self.currentPage) { (result) in
            self.users.append(contentsOf: result)
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
    func requestSearch(_ user: String, _ page: Int, _ completionHander: @escaping ((_ user: [User]) -> Void)) {
        Alamofire.request("https://api.github.com/search/users?q=\(user)&page=\(page)&per_page=\(self.itemPerPage)").responseObject { (response: DataResponse<Users>) in
            guard let listUser = response.result.value else { return}
            
            completionHander(listUser.items)
        }
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else { return UITableViewCell() }
        cell.loadData(item: users[indexPath.row])
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count-1 {
            self.loadMore()
        }
    }
}

