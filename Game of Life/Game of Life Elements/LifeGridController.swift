//
//  LifeGridController.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 01/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public protocol GridListener {
    func execute(forGrid grid: LifeGridController, offSet: SCNVector3?)
}

public class LifeGridController: GridController {
    private var listeners: [GridListener] = []

    func register(_ listener: GridListener) {
        listeners.append(listener)
    }

    func nextGeneration(moveBy: SCNVector3? = nil) {
        guard let lifeNodes = nodes as? [LifeNode] else {
            fatalError("Não eram life nodes")
        }

        var newCoordinates: Set<SCNVector3> = []
        let lockQueue = DispatchQueue.init(label: "Generation")
        let willMove = moveBy != nil
        DispatchQueue.concurrentPerform(iterations: nodes.count, execute: { index in
            lockQueue.sync {
                newCoordinates = newCoordinates.union(lifeNodes[index].getNextGenerationSpots(controller: self, willMove: willMove))
            }
        })

        for list in listeners {
            list.execute(forGrid: self, offSet: moveBy)
        }

        let offSet = moveBy ?? SCNVector3(0, 0, 0)
        for coordinate in newCoordinates {
            let node = LifeNodePool.getLife()
            addAt(node, coordinate: coordinate + offSet)
        }

        listeners = []
    }
}
