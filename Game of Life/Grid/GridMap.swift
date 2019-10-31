//
//  GridCoordinate.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public struct GridMap {
    let tileDimension: SCNVector3
    var occupieds: [String: SCNNode] = [:]

    func positionFor(coordinate: SCNVector3) -> SCNVector3 {
        return SCNVector3(tileDimension.x * coordinate.x, tileDimension.y * coordinate.y, tileDimension.z * coordinate.z)
    }

    func coordinateFor(position: SCNVector3) -> SCNVector3 {
        return SCNVector3(position.x / tileDimension.x, position.y / tileDimension.y, position.z / tileDimension.z)
    }

    mutating func register(_ object: SCNNode, coordinate: SCNVector3) {
        occupieds[vecToString(coordinate)] = object
    }

    mutating func remove(_ coordinate: SCNVector3) {
        occupieds[vecToString(coordinate)] = nil
    }

    mutating func remove(_ object: SCNNode) {
        let coordinate = coordinateFor(position: object.position)
        remove(coordinate: coordinate)
    }

    func checkOccupied(_ coordinate:SCNVector3) -> Bool {
        return occupieds[vecToString(coordinate)] != nil
    }

    func nodeFor(_ coordinate: SCNVector3) -> SCNNode? {
        return occupieds[vecToString(coordinate)]
    }

    private func vecToString(_ vec: SCNVector3) -> String {
        return "\(vec.x)\(vec.y)\(vec.z)"
    }
}
