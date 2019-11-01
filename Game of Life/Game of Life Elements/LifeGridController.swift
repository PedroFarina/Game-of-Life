//
//  LifeGridController.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 01/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public protocol GridListener {
    func execute(forGrid grid: LifeGridController)
}

public class LifeGridController: GridController {
    private var listeners: [GridListener] = []

    func register(_ listener: GridListener) {
        listeners.append(listener)
    }

    func nextGeneration() {
        guard let lifeNodes = nodes as? Set<LifeNode> else {
            fatalError("Não eram life nodes")
        }

        var newCoordinates: Set<SCNVector3> = []
        for node in lifeNodes {
            newCoordinates = newCoordinates.union(node.getNextGenerationSpots(controller: self))
        }

        for coordinate in newCoordinates {
            addAt(LifeNode(), coordinate: coordinate)
        }

        for list in listeners {
            list.execute(forGrid: self)
        }

        listeners = []
    }
}
