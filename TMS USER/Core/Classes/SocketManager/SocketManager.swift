//
//  SocketManager.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/4/21.
//

import SocketIO
import UIKit

let kHost = "http://185.78.165.78:3010"
let kTrackingByShipment = "trackingByShipment"
let kChat = "conversation"

typealias CompletionHandler = () -> Void
typealias MarkerCompletionHandler = (Result<SocketMarkerMapResponse?, Error>) -> Void
typealias ChatCompletionHandler = (Result<SocketChatResponse?, Error>) -> Void

extension Notification.Name {
    static let userTyping = Notification.Name("userTypingNotification")
}

final class SocketHelper: NSObject {
    static var shared = SocketHelper()
    
    private var _manager: SocketManager?
    private var _socket: SocketIOClient?
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        _manager = SocketManager(socketURL: URL(string: kHost)!, config: [.log(true), .compress])
        _socket = _manager?.defaultSocket
    }
    
    func establishConnection() {
        _socket?.connect()
    }
    
    func closeConnection() {
        _socket?.disconnect()
    }
}

// MARK: - kTrackingByShipment
extension SocketHelper {
    
    func emitTrackingByShipment(request: SocketMarkerMapRequest, completion: CompletionHandler) {
        let json = request.toJSON().convertToJSONString() ?? ""
        _socket?.emit(kTrackingByShipment, json)
        completion()
    }
    
    func fetchTrackingByShipment(completion: @escaping MarkerCompletionHandler) {
        _socket?.on(kTrackingByShipment) { [weak self] (result, ack) in
            do {
                guard result.count > 0, let data = Utils.jsonData(from: result) else {
                    return
                }
                
                let decode = try JSONDecoder().decode([SocketMarkerMapResponse].self, from: data)
                if let item = decode[0] as? SocketMarkerMapResponse {
                    completion(.success(item))
                } else {
                    completion(.success(nil))
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - kChat
extension SocketHelper {
    
    func emitChat(request: SocketChatRequest, completion: CompletionHandler) {
        let json = request.toJSON().convertToJSONString() ?? ""
        _socket?.emit(kChat, json)
        completion()
    }
    
    func fetchChat(completion: @escaping ChatCompletionHandler) {
        _socket?.on(kChat) { [weak self] (result, ack) in
            do {
                guard result.count > 0, let data = Utils.jsonData(from: result) else {
                    return
                }
                
                let decode = try JSONDecoder().decode([SocketChatResponse].self, from: data)
                if let item = decode[0] as? SocketChatResponse {
                    completion(.success(item))
                } else {
                    completion(.success(nil))
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

extension Decodable {
    init(from any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any)
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
