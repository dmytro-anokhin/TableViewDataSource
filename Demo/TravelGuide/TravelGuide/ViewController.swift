//
//  ViewController.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 23/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var dataSource: CompositeTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let model = try loadModel(withName: "Tokyo")

            dataSource = CompositeTableViewDataSource([
                HeaderDataSource(model: model),
                DetailDataSource(model: model)
            ])
        }
        catch {
            print(error)
        }

        dataSource?.configure(with: tableView)

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            do {
                let model = try loadModel(withName: "Tokyo")
                self.dataSource?.add(PlacesDataSource(model: model))
            }
            catch {
                print(error)
            }
        }
    }
}
