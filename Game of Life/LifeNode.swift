//
//  LifeNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

public class LifeNode: MyNode {
    var rules:[([MyNode]) -> Bool] = [ Rules.overPopulationRule, Rules.solitudeRule, Rules.socialRule ]

    func checkRules() -> Bool {
        var conformingRules: Bool = true

        let neighbors = getNeighbors()
        for rule in rules {
            conformingRules = conformingRules && rule(neighbors)
            if !conformingRules {
                return false
            }
        }
        return conformingRules
    }

}
