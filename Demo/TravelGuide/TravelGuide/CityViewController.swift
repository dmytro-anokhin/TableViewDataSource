//
//  CityViewController.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 23/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class CityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var dataSource: CompositeTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let model = try loadModel(withName: "Tokyo")

            dataSource = CompositeTableViewDataSource([
                HeaderDataSource(model: model),
                DetailDataSource(model: model),
                PlacesDataSource(model: model)
            ])
        }
        catch {
            print(error)
        }

        dataSource?.configure(with: tableView)
    }
}
