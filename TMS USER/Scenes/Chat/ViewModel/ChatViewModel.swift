//
//  ChatViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation
import UIKit
import GoogleMaps
import Combine

import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

protocol ChatProtocolInput {
    func getChat()
    func setOrderId(orderId: Int?)
//    func setCustomerItems(customerItems: CustomerItems?)
    func setRoomChatCustomer(items: RoomChatCustomerData?)
    
    func sendMessage(text: String)
}

protocol ChatProtocolOutput: class {
    var didGetChatSuccess: (() -> Void)? { get set }
    
    func getCurrentUser() -> SenderType
    func getNumberOfSections() -> Int
    func getItemSection(indexPath: IndexPath) -> MessageType
    
    func getIsFromCurrentSender(sender: SenderType) -> Bool
}

protocol ChatProtocol: ChatProtocolInput, ChatProtocolOutput {
    var input: ChatProtocolInput { get }
    var output: ChatProtocolOutput { get }
}

class ChatViewModel: ChatProtocol, ChatProtocolOutput {
    
    var input: ChatProtocolInput { return self }
    var output: ChatProtocolOutput { return self }
    
    // MARK: - Properties
    private var getMessageUseCase: GetMessageUseCase
    private var postMessageUseCase: PostMessageUseCase
    private var chatViewController: ChatViewController
    
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(
        chatViewController: ChatViewController,
        getMessageUseCase: GetMessageUseCase = GetMessageUseCaseImpl(),
        postMessageUseCase: PostMessageUseCase = PostMessageUseCaseImpl()
    ) {
        self.chatViewController = chatViewController
        self.getMessageUseCase = getMessageUseCase
        self.postMessageUseCase = postMessageUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetChatSuccess: (() -> Void)?

    public var orderId: Int? = nil
    public var itemRoomChatCustomer: RoomChatCustomerData?
    
    let currentUser = Sender(senderId: "self", displayName: "Nontawatkb")
    let otherUser = Sender(senderId: "other", displayName: "User")
    public var listMessages: [MessageType] = []
    
    func setOrderId(orderId: Int?) {
        self.orderId = orderId
    }
    
    func setRoomChatCustomer(items: RoomChatCustomerData?) {
        self.itemRoomChatCustomer = items
    }
    
    func getChat() {
        guard let cId = itemRoomChatCustomer?.cId else { return }
        var request: GetMessageRequest = GetMessageRequest()
        request.cId = cId
        request.page = 1
        request.limit = 10
        let currentDate: String = getCurrentDateToZ()
        request.chatTime = currentDate

        self.chatViewController.startLoding()
        self.getMessageUseCase.execute(request: request).sink { completion in
            debugPrint("getMessage \(completion)")
            self.chatViewController.stopLoding()
        } receiveValue: { resp in
            if let messages = resp?.data?.items {
                messages.forEach({ item in
                    if item.sender == "\(self.itemRoomChatCustomer?.cusId ?? 0)" {
                        self.listMessages.append(self.setMessageModel(sender: self.currentUser, text: item.message ?? ""))
                    } else {
                        self.listMessages.append(self.setMessageModel(sender: self.otherUser, text: item.message ?? ""))
                    }
                })
            }
            self.didGetChatSuccess?()
            
            
            //Connect Chat Socket
            self.fetchChat()
            
        }.store(in: &self.anyCancellable)
    }
    
    func getCurrentDateToZ() -> String {
        let currentDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.string(from: currentDate)
        return date
    }
    
}

//Chat
extension ChatViewModel {
    
    func getCurrentUser() -> SenderType {
        return self.currentUser
    }
    
    func getNumberOfSections() -> Int {
        return self.listMessages.count
    }
    
    func getItemSection(indexPath: IndexPath) -> MessageType {
        return self.listMessages[indexPath.section]
    }
    
    func setMessageModel(sender: SenderType, text: String) -> MessageType {
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font:UIFont.PrimaryText(size: 16), NSAttributedString.Key.foregroundColor: getIsFromCurrentSender(sender: sender) ? UIColor.white : UIColor.black])

        return Message(sender: sender, messageId: "\(self.listMessages.count)", sentDate: Date().addingTimeInterval(-86400), kind: .attributedText(myMutableString))
    }
    
    func getIsFromCurrentSender(sender: SenderType) -> Bool {
        return sender.senderId == "self"
    }
    
    func sendMessage(text: String) {
        guard let cId = itemRoomChatCustomer?.cId else { return }
        var request: PostMessageRequest = PostMessageRequest()
        request.cId = cId
        request.typeMsg = "MSG"
        request.typeSender = "CUST"
        request.message = text
        request.status = "UNREAD"

        self.chatViewController.startLoding()
        self.postMessageUseCase.execute(request: request).sink { completion in
            debugPrint("postMessage \(completion)")
            self.chatViewController.stopLoding()
        } receiveValue: { resp in
            self.listMessages.append(self.setMessageModel(sender: self.currentUser, text: text))
            self.didGetChatSuccess?()
        }.store(in: &self.anyCancellable)
    }
}

//MARK:- Fetch Socket
extension ChatViewModel {
    
//    func getMapMarkerResponse() -> [MarkerMapItems]? {
//        return self.listMapMarker
//    }
//
    func fetchChat() {
        SocketHelper.shared.fetchChat { result in
            switch result {
            case .success(let resp): break
                debugPrint("resp: \(resp)")
            case .failure(_ ):
                break
            }
        }
        emitChat()
    }

    private func emitChat(){
        var request: SocketChatRequest = SocketChatRequest()
        let accessToken = UserDefaultsKey.AccessToken.string
        guard let cId = itemRoomChatCustomer?.cId else { return }
        request.cId = cId
        request.token = accessToken
        request.status = "connect"
        SocketHelper.shared.emitChat(request: request) {
            debugPrint("request Chat \(request)")
        }
    }
}

