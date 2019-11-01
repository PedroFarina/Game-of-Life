//
//  GameViewController.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    private var scene: SCNScene = {
        guard let scene = SCNScene(named: "art.scnassets/GameScene.scn") else {
            fatalError("Não foi possível inicializar a cena")
        }
        return scene
    }()
    private lazy var sceneView: SCNView = {
        guard let view = self.view as? SCNView else {
            fatalError("Não foi possível inicializar a view")
        }
        view.delegate = self
        view.scene = scene
        view.allowsCameraControl = false
        view.showsStatistics = true
        return view
    }()
    
    private lazy var gridController: GridController = GridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(2, 1, 2))

    var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        return cameraNode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraNode)
        var lifes: [LifeNode] = []
        for i in 0...2 {
            let life = LifeNode()
            lifes.append(life)
            life.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
            gridController.addAt(life, coordinate: SCNVector3(-i, 0, 0))
        }

        // place the camera
        cameraNode.position = SCNVector3(x: -2, y: 9, z: 20)
        cameraNode.eulerAngles = SCNVector3(-0.5, 0, 0)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    func makeNewGeneration() {
        guard let lifeNodes = gridController.nodes as? Set<LifeNode> else {
            fatalError("Não eram life nodes")
        }
        var dieNodes: [LifeNode] = []
        var newSpawns: [SCNVector3] = []
        for node in lifeNodes {
            let answer = node.nextGeneration()
            if !answer.0 {
                dieNodes.append(node)
            }
            newSpawns.append(contentsOf: answer.1)
        }

        for node in lifeNodes {
            if !dieNodes.contains(node) {
                let life = LifeNode()
                life.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                var newCoordinate = gridController.gridMap.coordinateFor(position: node.position)
                newCoordinate.y -= 1
                gridController.addAt(life, coordinate: newCoordinate)
            }
            gridController.untrack(node)
        }
//        for node in dieNodes {
//            gridController.remove(node)
//        }
        for place in newSpawns {
            let life = LifeNode()
            life.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
            var newPlace = place
            newPlace.y -= 1
            gridController.addAt(life, coordinate: newPlace)
        }
        cameraNode.runAction(SCNAction.move(by: SCNVector3(0, -1, 0), duration: 0))
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        makeNewGeneration()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
