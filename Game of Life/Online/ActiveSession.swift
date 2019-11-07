//
//  ActiveSession.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 07/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public enum PlayerType: String {
    case Host = "player1"
    case Join = "player2"
}

public protocol SessionWatcher {
    func begin(at: Date)
    func gotInfo(input: PlayerInputInfo)
}

public class ActiveSession {

    private let watcher: SessionWatcher

    private let address = "https://be-life-server.herokuapp.com/api"
    var waitTimer:Timer?
    var waitingForResult: Bool = false

    var session: Session?
    var rounds: Int? {
        return session?.rounds
    }
    var player1: PlayerInputInfo? {
        return session?.player1
    }
    var player2: PlayerInputInfo? {
        return session?.player2
    }
    var playerType: PlayerType

    init(idSession: String, name: String, playerType: PlayerType, watcher: SessionWatcher){
        self.playerType = playerType
        self.watcher = watcher
        let dic: [String: Any] = ["idSession": idSession, playerType.rawValue: ["name": name]]
        joinSession(dic, playerType: playerType)
    }

    func joinSession(_ dic: [String: Any], playerType: PlayerType) {
        APIRequests.postRequest(url: "\(address)/session", params: dic, decodableType: ServerAnswer<Session>.self) { (answer) in
            switch answer {
            case .result(let result as ServerAnswer<Session>):
                guard let session = result.content else {
                    fatalError(result.msg ?? "Não foi possível criar uma sessão")
                }
                self.session = session
                if playerType == .Host {
                    self.waitTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: self.waitForPlayerTwo(_:))
                } else {
                    var date = Date()
                    date.addTimeInterval(TimeInterval(10))
                    self.watcher.begin(at: date)
                }
            case .error(let error):
                fatalError(error.localizedDescription)
            default:
                fatalError("Não foi retornada uma sessão")
            }
        }
    }

    func waitForPlayerTwo(_ timer: Timer) {
        if waitingForResult {
            return
        }
        waitingForResult = true
        APIRequests.getRequest(url: "\(address)/session/\(session?.idSession ?? "")", decodableType: ServerAnswer<Session>.self) { (answer) in
            switch answer {
                case .result(let result as ServerAnswer<Session>):
                    guard let session = result.content else {
                        fatalError(result.msg ?? "Não foi possível criar uma sessão")
                    }
                    if session.updatedAt != session.createdAt,
                        var updatedTime = session.updatedAt {

                        self.session = session
                        self.waitTimer?.invalidate()
                        updatedTime.addTimeInterval(TimeInterval(10))
                        self.watcher.begin(at: updatedTime)
                    }
                case .error(let error):
                    fatalError(error.localizedDescription)
                default:
                    fatalError("Não foi retornada uma sessão")
            }
            self.waitingForResult = false
        }
    }

    func sendInfo(playerInput: PlayerInputInfo) {
        let dic: [String: Any] = ["_id": playerInput._id ?? "", "nodesPositions": playerInput.nodesPositions ?? []]
        APIRequests.postRequest(url: "\(address)/nodes", params: dic) {_ in }
        waitTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: getInfo(_:))
    }

    func getInfo(_ timer: Timer) {
        if waitingForResult {
            return
        }
        waitingForResult = true
        guard let player = playerType == .Host ? player1 : player2, let id = player._id else {
            fatalError("Não havia player para pegar o ID")
        }
        APIRequests.getRequest(url: "\(address)/nodes/\(id)", decodableType: ServerAnswer<PlayerInputInfo>.self) { (answer) in
            switch answer {
                case .result(let result as ServerAnswer<PlayerInputInfo>):
                    guard let info = result.content else {
                        fatalError("Não haviam array de nodes adversários")
                    }
                    self.watcher.gotInfo(input: info)
                break
                case .error(let error):
                    fatalError(error.localizedDescription)
                default:
                    fatalError("Não foi possível pegar os nodes adversários")
            }
            self.waitingForResult = false
        }

    }
}
