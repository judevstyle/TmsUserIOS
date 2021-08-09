//
//  SocketManager.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/4/21.
//

import SocketIO
import UIKit

let kHost = "http://43.229.149.79:3010"
let kDashboard = "dashboard-balance"
let kTrackingByComp = "trackingByComp"

typealias CompletionHandler = () -> Void
typealias DashboardCompletionHandler = (Result<SocketDashboardResponse?, Error>) -> Void
typealias MarkerCompletionHandler = (Result<SocketMarkerMapResponse?, Error>) -> Void

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
    
    func emitDashboard(request: SocketDashboardRequest, completion: CompletionHandler) {
        let json = request.toJSON().convertToJSONString() ?? ""
        _socket?.emit(kDashboard, json)
        completion()
    }
    
    func fetchDashboard(completion: @escaping DashboardCompletionHandler) {
        _socket?.on(kDashboard) { [weak self] (result, ack) in
            do {
                guard result.count > 0, let data = Utils.jsonData(from: result) else {
                    return
                }
                
                let decode = try JSONDecoder().decode([SocketDashboardResponse].self, from: data)
                if let item = decode[0] as? SocketDashboardResponse {
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
    
    
    func emitTrackingByComp(request: SocketMarkerMapRequest, completion: CompletionHandler) {
        let json = request.toJSON().convertToJSONString() ?? ""
        _socket?.emit(kTrackingByComp, json)
        completion()
    }
    
    func fetchTrackingByComp(completion: @escaping MarkerCompletionHandler) {
        _socket?.on(kTrackingByComp) { [weak self] (result, ack) in
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


extension Decodable {
    init(from any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any)
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}


//struct Root: Codable {
//    let  data: InnerItem?
//}
//struct InnerItem:Codable {
//    let  total_balance: Int?
//    let  total_cash: Int?
//    let  total_credit: Int?
//
//    private enum CodingKeys : String, CodingKey {
//        case total_balance = "total_balance", total_cash = "total_cash", total_credit = "total_credit"
//    }
//}
