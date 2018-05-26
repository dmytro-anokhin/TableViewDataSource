//
//  CompositeType.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//


public protocol Composable: class {

    var parent: CompositeType? { get set }
}


public protocol CompositeType: class {

    func add(_ child: Composable)

    func remove(_ child: Composable)

    var children: [Composable] { get }
}
