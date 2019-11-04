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
        view.allowsCameraControl = true
        view.showsStatistics = false
        return view
    }()
    
    private lazy var gridController: LifeGridController = LifeGridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(1, 1, 1))

    var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        return cameraNode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 1000, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraNode)
        for i in -5...4 {
            gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(i, 0, 0))
        }

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 50, z: 0)
        cameraNode.eulerAngles = SCNVector3(-89.5, 0, 0)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    func makeNewGeneration() {
        gridController.nextGeneration()
    }

    func makeGlider() {
        for i in 0...2 {
            let life = LifeNodePool.getLife()
            gridController.addAt(life, coordinate: SCNVector3(0, 0, -i))
        }
        gridController.addAt(LifeNodePool.getLife(), position: SCNVector3(1,0,0))
        gridController.addAt(LifeNodePool.getLife(), position: SCNVector3(2,0,-1))
    }

    let timeToLoop = 0.5
    var currentTime = 0.5
    var enabled = false
    var generation = 0
    var offset = SCNVector3(0, 1, -1)
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if enabled {
            if time > currentTime {
                if generation == 16 {
                    for node in scene.rootNode.childNodes {
                        node.scale = node.scale + 0.15
                    }
                } else {
                    generation += 1
                    gridController.nextGeneration(moveBy: offset)
                }
                currentTime = time + timeToLoop
            }
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        enabled = true
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
