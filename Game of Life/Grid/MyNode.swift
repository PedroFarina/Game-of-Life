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

    public func getInfo() -> ([MyNode], [SCNVector3]) {
        return getInfoIn(SCNVector3(1, 1, 1))
    }

    public func getInfoIn(_ range: SCNVector3) -> ([MyNode], [SCNVector3]) {
        guard let myCoordinate = self.gridMap?.coordinateFor(position: position) else {
            return ([], [])
        }
        var nodes: [MyNode] = []
        var vectors: [SCNVector3] = []

        for xDim in Int(myCoordinate.x - range.x) ... Int(myCoordinate.x + range.x) {
            for yDim in Int(myCoordinate.y - range.y) ... Int(myCoordinate.y + range.y) {
                for zDim in Int(myCoordinate.z - range.z) ... Int(myCoordinate.z + range.z) {
                    let checkIndex = SCNVector3(xDim, yDim, zDim)
                    if let neighborNode = gridMap?.nodeFor(checkIndex) {
                        nodes.append(neighborNode)
                    } else {
                        vectors.append(checkIndex)
                    }
                }
            }
        }

        return (nodes, vectors)
    }

    func getNeighbors() -> [MyNode] {
        return getNeighborsIn(SCNVector3(1, 1, 1))
    }

    func getNeighborsIn(_ range: SCNVector3) -> [MyNode] {
        return getInfoIn(range).0
    }

    func getBlank() -> [SCNVector3] {
        return getBlankIn(SCNVector3(1, 1, 1))
    }

    func getBlankIn(_ range: SCNVector3) -> [SCNVector3] {
        return getInfoIn(range).1
    }
}
