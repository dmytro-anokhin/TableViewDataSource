//
//  PlacesGroupHeaderView.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 25/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit


class PlacesGroupHeaderView: UITableViewHeaderFooterView {

    private(set) var label: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        init_PlacesGroupHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_PlacesGroupHeaderView()
    }

    private func init_PlacesGroupHeaderView() {
        label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .light)

        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        backgroundView = UIView(frame: .zero)
        backgroundView?.backgroundColor = .white

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 4.0),
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
