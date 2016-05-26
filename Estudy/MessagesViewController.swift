//
//  MessagesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import SocketIOClientSwift

class MessagesViewController: ApplicationViewController, UITableViewDelegate, UITableViewDataSource, Messages {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageFormView: UIView!
    @IBOutlet var messageFormHeightConstraint: NSLayoutConstraint!
    @IBOutlet var messageFormHeightValue: NSLayoutConstraint!
    
    var keyboardIsVisible = false
    var messageFormDefaultHeight: CGFloat!
    let minFormHeight = CGFloat(50)
    let maxFormHeight = CGFloat(160)
    var defaultKeyboardHeight: CGFloat!
    var chat: Chat!
    var messages: [Message]!
    var tableCells: [CommonMessageCell]!
    var messageFormContent: MessageForm!
    var cellIdentifier = "messageCell"
    var currentUserCellIdentifier = "currentUserMessageCell"
    var personalCellIdentifier = "personalCellIdentifier"
    var currentUserPersonalCellIdentifier = "currentUserPersonalCellIdentifier"
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultUI()
        registerKeyboardNotifications()
        setSocketData()
        setMessageForm();
        setNavigationBarData()
        registerCellsForTable()
        loadChat()
        tableView.estimatedRowHeight = 144.0
        tableView.rowHeight = UITableViewAutomaticDimension
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didRotate:"), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
//    {
//    [super viewDidAppear:animated];
//    [self.tableView reloadData];
//    }
    
    //MARK: API Requests
    func createMessage(text: String!) {
        let user = AuthService.sharedInstance.currentUser
        var params: NSDictionary = [
            "message": ["user_id": user.id as Int, "chat_id": chat.id!, "text": text!]
        ]
        MessagesFactory.sharedInstance.create(params, success: successCreateMessageCallback, error: failureCreateMessageCallback)
    }
    
    func loadChat() {
        ChatFactory.get(chat.id!, success: successChatLoadCallback, error: failureChatLoadCallback)
    }
    
    //MARK: Succeess API callbacks
    func successChatLoadCallback(chat: Chat!) {
        self.chat = chat
        self.chat.messages = self.chat.messages.reverse()
        self.tableView.reloadData()
    }
    
    func successCreateMessageCallback(message: Message!) {
        chat.messages.append(message)
        tableView.reloadData()
        scrollDownTableView()
        messageFormContent.resetFormText()
        setDefaultMessageFormHeight()
    }
    
    //MARK: Failure API callbacks
    func failureCreateMessageCallback(error: ServerError) {
        
    }
    
    func failureChatLoadCallback(error: ServerError) {
        
    }
    
    //MARK: UITableViewDelegate and UITableViewDataSource delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        
        if (message.user.id == AuthService.sharedInstance.currentUser.id) {
                            return currentUserMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
                        }
                        else {
                            return messageCellInstance(message, indexPath: indexPath) as UITableViewCell
                        }
//        let cell = tableView.dequeueReusableCellWithIdentifier("chatsCell", forIndexPath: indexPath)
//        cell.textLabel?.text = message.text
//        cell.textLabel?.lineBreakMode = .ByWordWrapping
//        cell.textLabel?.numberOfLines = 0
////
//        cell.layoutIfNeeded()
//        cell.setDataToMessageData(message)
//        return cell
//
//        if (hasMultipleUsers()) {
//            
//        }
//        else {
//            if (message.user.id == AuthService.sharedInstance.currentUser.id) {
//                return currentUserPersonalMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
//            }
//            else {
//                return personalMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
//            }
//        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var message = chat.messages[indexPath.row]
//        var messageText = message.text as NSString
//        var size = messageText.sizeWithAttributes(["NSFontAttributeName": UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19.0)!])
//        return size.width
//    }
//
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var message = chat.messages[indexPath.row]
//        var messageText = message.text as NSString
//        var arr = message.text.componentsSeparatedByString(" ")
//        arr.map { substring -> String in
//            return "\(substring)\n"
//        }
//        let modifiedText: NSString! = arr.joinWithSeparator("")
//        var size = messageText.sizeWithAttributes(["NSFontAttributeName": UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19.0)!])
//        var diffsize = messageText.boundingRectWithSize(CGSizeMake(300, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: ["NSFontAttributeName": UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19.0)!], context: nil)
//        return diffsize.height
//    }
    
    func currentUserMessageCellInstance(message: Message, indexPath: NSIndexPath) -> CurrentUserMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(currentUserCellIdentifier, forIndexPath: indexPath) as! CurrentUserMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func messageCellInstance(message: Message, indexPath: NSIndexPath) -> MessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessagesCell
        cell.setDataToMessageData(message)
        cell.messageCellText.lineBreakMode = .ByWordWrapping
        cell.messageCellText.numberOfLines = 0
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    func personalMessageCellInstance(message: Message, indexPath: NSIndexPath) -> PersonalMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(personalCellIdentifier, forIndexPath: indexPath) as! PersonalMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func currentUserPersonalMessageCellInstance(message: Message, indexPath: NSIndexPath) -> CurrentUserPersonalMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(currentUserPersonalCellIdentifier, forIndexPath: indexPath) as! CurrentUserPersonalMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    //MARK: Setup UI
    
    func registerCellsForTable() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "chatsCell")
//        tableView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat.max), animated: true)
//        tableView.registerClass(CommonMessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.registerNib(UINib(nibName: "CurrentUserMessageCell", bundle: nil), forCellReuseIdentifier: currentUserCellIdentifier)
//        tableView.registerNib(UINib(nibName: "PersonalMessageCell", bundle: nil), forCellReuseIdentifier: personalCellIdentifier)
//        tableView.registerNib(UINib(nibName: "CurrentUserPersonalMessageCell", bundle: nil), forCellReuseIdentifier: currentUserPersonalCellIdentifier)
    }
    
    func scrollDownTableView() {
        var diff: CGFloat!
        let indexPath = NSIndexPath(forRow: chat.messages.count, inSection: 0)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if (keyboardIsVisible) {
            diff = cell!.frame.origin.y - defaultKeyboardHeight - minFormHeight
        }
        else {
            diff = cell!.frame.origin.y
        }
        var y = diff
        tableView.setContentOffset(CGPointMake(0, y ), animated: true)
    }
    
    func hasMultipleUsers() -> Bool {
        return chat.users!.count > 2
    }
    
    func setNavigationBarData() {
        if (!hasMultipleUsers()) {
            let view = NSBundle.mainBundle().loadNibNamed("PersonalNavigationBar", owner: nil, options: nil).first as! PersonalNavigationBar
            var member = returnOtherChatMembers().first as! User!
            view.setMemberData(member)
            self.navigationItem.titleView = view
        }
    }
    
    func setMessageForm() {
        messageFormContent = NSBundle.mainBundle().loadNibNamed("MessageForm", owner: nil, options: nil).first as! MessageForm
        messageFormDefaultHeight = view.frame.size.height
        messageFormContent.delegate = self
        messageFormView.addSubview(messageFormContent)
    }
    
    
    func textViewChangeSize(textView: UITextView!) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        if (newSize.height > minFormHeight && newSize.height <= maxFormHeight) {
            messageFormHeightValue.constant = newSize.height
        }
        if (textView.text == "") {
            setDefaultMessageFormHeight()
        }
    }
    
    func setDefaultUI() {
        self.tableView.backgroundColor = Constants.Colors.mainBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
//        self.tableView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    func setDefaultMessageFormHeight() {
        messageFormHeightValue.constant = minFormHeight
    }
    
    //MARK: Keyboard methods
    
    func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if (!keyboardIsVisible) {
            keyboardIsVisible = true
            var height = getKeyboardHeight(notification)
            messageFormHeightConstraint.constant = messageFormHeightConstraint.constant + height
            scrollDownTableView()
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        if (keyboardIsVisible) {
            keyboardIsVisible = false
            var height = getKeyboardHeight(notification)
            messageFormHeightConstraint.constant = messageFormHeightConstraint.constant - height
            
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        defaultKeyboardHeight = keyboardRectangle.height
        return defaultKeyboardHeight
    }

    
    //MARK: Websockets methods
    func setSocketData() {
        socket.on("user\(AuthService.sharedInstance.currentUser.id)chatmessage") {data, ack in
            if let action = data.first!["action"] {
                switch(String(action!)) {
                case "chatmessage":
                    if let object = data.first!["obj"] {
                        self.addMessageToList(String(object!))
                    }
                default: break
                }
            }
        }
        
        socket.connect()
    }

    
    //MARK: Websockets callbacks
    func addMessageToList(messageData: String!) {
        let message = MessagesFactory.sharedInstance.parseObject(messageData)
        if (message.user.id != AuthService.sharedInstance.currentUser.id) {
            chat.messages.append(message)
            tableView.reloadData()
            scrollDownTableView()
        }
    }
    
    //MARK: Utils
    func returnOtherChatMembers() -> [User] {
        return (chat.users?.filter({ $0.id != AuthService.sharedInstance.currentUser.id }))!
    }
    
    

}