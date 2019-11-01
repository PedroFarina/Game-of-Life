//
//  GridManager.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class GridController {
    private let scene: SCNScene
    private let sceneView: SCNView
    public private(set) var gridMap: GridMap
    public private(set) var nodes: [MyNode] = []
//    private let colors: [Int: UIColor] = {
//        var colorAsFuck: [Int: UIColor] = [:]
//        for i in 0 ... 10000 {
//            colorAsFuck[i-5000] = UIColor.random()
//        }
//        return colorAsFuck
//    }()

    init(scene: SCNScene, sceneView: SCNView, tileDimension: SCNVector3) {
        self.scene = scene
        self.sceneView = sceneView
        gridMap = GridMap(tileDimension: tileDimension)
    }

    public func addAt(_ object: MyNode, coordinate: SCNVector3) {
        if !gridMap.checkOccupied(coordinate) {
            object.position = gridMap.positionFor(coordinate: coordinate)
//            object.geometry?.firstMaterial?.diffuse.contents = colors[Int(object.position.y)]
            nodes.append(object)
            gridMap.register(object, coordinate: coordinate)
            scene.rootNode.addChildNode(object)
            object.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 2, y: 2, z: 2, duration: 1)))
        }
    }

    public func addAt(_ object: MyNode, position: SCNVector3) {
        let coordinate = gridMap.coordinateFor(position: position)
        addAt(object, coordinate: coordinate)
    }

    public func removeAt(_ coordinate: SCNVector3) {
        if let object = gridMap.nodeFor(coordinate) {
            if let index = nodes.firstIndex(of: object) {
                nodes.remove(at: index)
            }
            object.removeFromParentNode()
            gridMap.remove(coordinate)
            LifeNodePool.release(object)
        }
    }

    public func remove(_ object: MyNode) {
        if let index = nodes.firstIndex(of: object) {
            nodes.remove(at: index)
        }
        object.removeFromParentNode()
        gridMap.remove(object)
        LifeNodePool.release(object)
    }

    public func untrack(_ object: MyNode) {
        if let index = nodes.firstIndex(of: object) {
            nodes.remove(at: index)
        }
        gridMap.remove(object)
    }
}
