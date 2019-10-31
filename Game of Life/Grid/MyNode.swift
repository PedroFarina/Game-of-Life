//
//  PersonNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class MyNode: SCNNode {
    public weak var gridMap: GridMap?

    func getNeighbors() -> [MyNode] {
        return getNeighborsIn(SCNVector3(1, 1, 1))
    }

    func getNeighborsIn(_ range: SCNVector3) -> [MyNode] {
        guard let myCoordinate = self.gridMap?.coordinateFor(position: position) else {
            return []
        }
        var nodes:[MyNode] = []

        for xDim in Int(myCoordinate.x - range.x) ... Int(myCoordinate.x + range.x) {
            for yDim in Int(myCoordinate.y - range.y) ... Int(myCoordinate.y + range.y) {
                for zDim in Int(myCoordinate.z - range.z) ... Int(myCoordinate.z + range.z) {
                    let checkIndex = SCNVector3(xDim, yDim, zDim)
                    if let neighborNode = gridMap?.nodeFor(checkIndex) {
                        nodes.append(neighborNode)
                    }
                }
            }
        }

        return nodes
    }
}
