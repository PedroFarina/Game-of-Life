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
import ARKit

class GameViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    let timeToLoop = 0.5
    lazy var currentTime = timeToLoop
    var loopEnabled: Bool = false {
        didSet {
            versusView.isHidden = false
            versusView.start()
        }
    }
    @IBOutlet weak var btnPlace: UIButton!

    @IBOutlet weak var versusView: VersusView!
    @IBOutlet var sceneView: ARView!
    var calibrated: Bool = false

    @IBOutlet weak var lblSessionState: UILabel!
    var sessionState: ARCamera.TrackingState = .notAvailable {
        didSet {
            switch sessionState {
            case .normal:
                lblSessionState.isHidden = true
            case .notAvailable:
                lblSessionState.isHidden = false
                lblSessionState.text = "Camera unavailable"
            case .limited(let reason):
                lblSessionState.isHidden = false
                var txt = ""
                switch reason {
                case .excessiveMotion:
                    txt = "The camera movement is too fast"
                case .initializing, .relocalizing:
                    txt = "Calibrating sensors"
                case .insufficientFeatures:
                    txt = "Insufficient light conditions"
                @unknown default:
                    fatalError()
                }
                lblSessionState.text = txt
            }
        }
    }

    private var featurePointsEnough:Bool = false

    var allRight: Bool {
        return calibrated && featurePointsEnough
    }

    public private(set) var scene: SCNScene = SCNScene()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LifeNodePool.start()
        sceneView.runConfig()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private lazy var gridController: LifeGridController = LifeGridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(0.1, 0.1, 0.1))


    override func viewDidLoad() {
        sceneView.controller = self
        super.viewDidLoad()
        makeLights()
    }

    func makeLights() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 100, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }

    func makeNewGeneration() {
        gridController.nextGeneration()
    }

    func makeGlider() {
        self.gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(-1, -10,-12))
        for i in 0...2 {
            let life = LifeNodePool.getLife()
            self.gridController.addAt(life, coordinate: SCNVector3(-i, -10, -10))
        }
        self.gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(-1, -10,-12))
        self.gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(0, -10,-11))
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if loopEnabled {
            if time > currentTime {
                gridController.nextGeneration()
                currentTime = time + timeToLoop
            }
        }
    }

    lazy var ghostNode: LifeNode = {
        let node = LifeNode()
        node.opacity = 0.6
        node.setColor(.green)
        node.position = gridController.gridMap.positionFor(coordinate: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(node)
        return node
    }()
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        sessionState = frame.camera.trackingState
        if frame.rawFeaturePoints?.points.count ?? 0 > 50 {
            featurePointsEnough = true
        }
        if btnPlace == nil {
            return
        }
        let results = sceneView.castRay(at: sceneView.center)
        if let rayCastResult = results.first {
            let pos = SCNVector3(rayCastResult.worldTransform.translation)
            var coord = gridController.gridMap.coordinateFor(position: pos)
            coord.y = -10
            if gridController.gridMap.checkOccupied(coord) {
                ghostNode.setColor(.red)
                btnPlace.setTitleColor(.red, for: .normal)
            } else {
                ghostNode.setColor(.green)
                btnPlace.setTitleColor(.green, for: .normal)
            }
            let gridPos = gridController.gridMap.positionFor(coordinate: coord)
            ghostNode.position = gridPos
        }
    }
    
    var planeNode: SCNNode = SCNNode()
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        if featurePointsEnough {
            let center = SCNVector3(planeAnchor.center)
            gridController.gridMap.changeOrigin(to: center)
            sceneView.stopPlaneDetection()
        }
    }
    
    @IBAction func btnPlaceTap(_ sender: UIButton) {
        if btnPlace.titleColor(for: .normal) == .green {
            gridController.addAt(LifeNodePool.getLife(), position: ghostNode.position)
        }
    }

    @IBAction func btnGoTap(_ sender: UIButton) {
        loopEnabled = true
        if loopEnabled {
            ghostNode.removeFromParentNode()
            sender.removeFromSuperview()
            btnPlace.removeFromSuperview()
        }
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
