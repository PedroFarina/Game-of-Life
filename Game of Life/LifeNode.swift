//
//  LifeNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class LifeNode: MyNode {
    var rules:[([MyNode]) -> Bool] = [ Rules.overPopulationRule, Rules.solitudeRule ]

    func nextGeneration() -> (Bool, Set<SCNVector3>) {
        var conformingRules: Bool = true

        let info = getInfo()
        for rule in rules {
            conformingRules = conformingRules && rule(info.0)
            if !conformingRules {
                break
            }
        }

        var newSpawns: Set<SCNVector3> = []
        for blank in info.1 {
            if !newSpawns.contains(blank) &&
                gridMap?.nodesFor(blank.pointsAround()).count ?? 0 >= 3 {
                newSpawns.insert(blank)
            }
        }

        return (conformingRules, newSpawns)
    }
}
