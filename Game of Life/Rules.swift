//
//  Rules.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

public class Rules {
    private init() {
    }

    public static func solitudeRule(_ neighbors: [MyNode]) -> Bool {
        return neighbors.count > 1
    }

    public static func overPopulationRule(_ neighbors: [MyNode]) -> Bool {
        return neighbors.count < 4
    }
}
