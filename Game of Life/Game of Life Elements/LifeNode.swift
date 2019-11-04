//
//  LifeNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class LifeNode: MyNode, GridListener {

    override init() {
        super.init()
        let myGeometry = SCNBox(
            width: 1,
            height: 1,
            length: 1,
            chamferRadius: 0.3)

        myGeometry.firstMaterial?.diffuse.contents = UIColor.random()

        geometry = myGeometry
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }

    public func setColor(_ color: UIColor) {
        geometry?.firstMaterial?.diffuse.contents = color
    }
    
    var rules:[([MyNode]) -> Bool] = [ Rules.overPopulationRule, Rules.solitudeRule ]
    var willLive: Bool = true

    func getNextGenerationSpots(controller: LifeGridController, willMove: Bool = false) -> Set<SCNVector3> {
        let info = getInfo()

        for rule in rules {
            willLive = willLive && rule(info.0)
            if !willMove && !willLive {
                controller.register(self)
                break
            }
        }

        if willMove {
            controller.register(self)
        }

        var newSpawns: Set<SCNVector3> = []
        for blank in info.1 {
            if !newSpawns.contains(blank) &&
                gridMap?.nodesFor(blank.pointsAround()).count ?? 0 == 3 {
                newSpawns.insert(blank)
            }
        }

        return newSpawns
    }

    public func execute(forGrid grid: LifeGridController, offSet: SCNVector3? = nil) {
        if let offSet = offSet, let gridMap = gridMap {
            grid.untrack(self)
            if willLive {
                let next = LifeNodePool.getLife()
                let myCoord = gridMap.coordinateFor(position: position)
                let pos = gridMap.positionFor(coordinate: myCoord + offSet)
                grid.addAt(next, position: pos)
            }
        } else if !willLive {
            grid.remove(self)
        }
    }
}
