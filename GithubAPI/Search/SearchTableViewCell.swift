//
//  SearchTableViewCell.swift
//  GithubAPI
//
//  Created by Van Le on 9/18/19.
//  Copyright © 2019 ITPS. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(item: User) {
        userNameLabel.text = item.login
        guard let url = URL(string: item.avatar_url) else { return }
        avatarImage.kf.setImage(with: url)
    }

}
