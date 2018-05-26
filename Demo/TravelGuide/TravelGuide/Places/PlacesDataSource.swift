//
//  PlacesDataSource.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 25/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class PlacesDataSource: TableViewDataSource {

    let model: Model

    init(model: Model) {
        self.model = model
    }

    override var numberOfSections: Int {
        return model.groups.count
    }

    override func registerReusableViews(with tableView: UITableView) {
        tableView.register(UINib(nibName: "PlaceCell", bundle: Bundle(for: PlaceCell.self)), forCellReuseIdentifier: "PlaceCell")
        tableView.register(PlacesGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: "PlacesGroupHeaderView")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = model.groups[section]
        return group.places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell

        let group = model.groups[indexPath.section]
        let place = group.places[indexPath.row]

        cell.nameLabel?.text = place.name
        cell.descriptionTextLabel?.text = place.text

        if let path = Bundle.main.path(forResource: place.imageName, ofType: nil) {
            cell.thumbnailImageView?.image = UIImage(contentsOfFile: path)
        }
        else {
            cell.thumbnailImageView?.image = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PlacesGroupHeaderView") as! PlacesGroupHeaderView

        let group = model.groups[section]
        view.label.text = group.name

        return view
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 34.0
    }
}
