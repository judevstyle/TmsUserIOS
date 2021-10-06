//
//  ChatViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/16/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    // ViewModel
    lazy var viewModel: ChatProtocol = {
        let vm = ChatViewModel(chatViewController: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        viewModel.input.getChat()
        
    }
    
    
    func configure(_ interface: ChatProtocol) {
        self.viewModel = interface
    }
    
}

// MARK: - Binding
extension ChatViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetChatSuccess = didGetChatSuccess()
    }
    
    func didGetChatSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.messagesCollectionView.reloadData()
//            weakSelf.messagesCollectionView.scrollToLastItem()
        }
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        return self.viewModel.output.getCurrentUser()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = self.viewModel.output.getItemSection(indexPath: indexPath)
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.viewModel.output.getNumberOfSections()
    }
    
    func cellBottomLabelAttributedText(for message: MessageKit.MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.PrimaryText(size: 12), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageKit.MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.PrimaryText(size: 12)])
    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        //If it's current user show current user photo.
//        if message.sender.senderId == "self" {
//            let sigil = Sigil(ship: Sigil.Ship(rawValue: message.sender.senderId)!, color: .black).image(with: CGSize(width: 24.0, height: 24.0))
//            let avatar = Avatar(image: sigil, initials: "")
//                avatarView.set(avatar: avatar)
//                        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
//
//        } else {
//            avatarView.isHidden = true
//        }
//    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //If it's current user show current user photo.
//        if message.sender.senderId == "self" {
//            let avatar = Avatar(image: UIImage(named: "placeholder"), initials: "")
//                avatarView.set(avatar: avatar)
//
//        } else {
//            avatarView.isHidden = true
//        }
        let avatar = Avatar(image: UIImage(named: "avatar"), initials: "")
        avatarView.set(avatar: avatar)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        return .bubble
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let message = viewModel.output.getItemSection(indexPath: indexPath)
        return viewModel.output.getIsFromCurrentSender(sender: message.sender) ? UIColor.Primary : UIColor.lightGray.withAlphaComponent(0.1)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.viewModel.input.sendMessage(text: text)
        inputBar.inputTextView.text = ""
    }
    
}
