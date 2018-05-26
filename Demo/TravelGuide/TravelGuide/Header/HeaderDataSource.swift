//
//  HeaderDataSource.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 25/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class HeaderDataSource: TableViewDataSource {

    let model: Model

    init(model: Model) {
        self.model = model
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell

        if let path = Bundle.main.path(forResource: model.imageName, ofType: nil) {
            cell.headerImageView.image = UIImage(contentsOfFile: path)
        }
        else {
            cell.headerImageView.image = nil
        }

        cell.titleLabel.text = model.title
        cell.subtitleLabel.text = model.subtitle

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211.0
    }
}
