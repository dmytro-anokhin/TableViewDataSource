//
//  Model.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 25/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import Foundation


func loadModel(withName name: String) throws -> Model {
    let path = Bundle.main.url(forResource: name, withExtension: "json")!

    do {
        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()

        return try decoder.decode(Model.self, from: data)
    }
    catch {
        throw error
    }
}


struct Model: Codable {

    let title: String

    let subtitle: String

    let imageName: String

    let detail: Detail

    let groups: [PlacesGroup]
}


struct Detail: Codable {

    let title: String

    let shortText: String

    let fullText: String
}


struct PlacesGroup: Codable {

    let name: String

    let places: [Place]
}


struct Place: Codable {

    let name: String

    let text: String

    let imageName: String
}
