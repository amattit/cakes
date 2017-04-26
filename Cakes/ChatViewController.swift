//
//  ChatViewController.swift
//  Cakes
//
//  Created by Михаил Серёгин on 11.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var chatList: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var message = [Message]()
    var delegate: GetChatDelegate?
    var chatService = GetChat()
    var newMessage = Message(message: "пусто", author: nil, image: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        //Подписываемся на уведомления о появлении и скрытии клавиатуры
        registerForNotification()
        
        //Устанавливаем делегат для сервиса чата
        chatService.delegate = self
        chatService.getChatUpdate()
        
        //Устанавливаем делегат ввода сообщения
        messageField.delegate = self
        
        //Автоматический расчёт высоты ячейки таблицы
        chatList.estimatedRowHeight = 56.0
        chatList.rowHeight = UITableViewAutomaticDimension
        

    }
//    func showAlert(withTitle title: String, message: String) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: title,
//                                          message: message, preferredStyle: .alert)
//            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
//            alert.addAction(dismissAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    //Отписываемся от уведомлений при уходе с экрана
    deinit {
        removeKeyBoardNotification()
    }
    
    //Функция подписывания на уведомления о появлении и скрытии клавиатуры
    func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Функция отписывания от получения уведомления о появлении и скрытии клавиатуры
    func removeKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //функция поведения экрана чата при появлении клавиатуры
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    //функция поведения экрана чата при скрытии клавиатуры
    func kbWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    //функция выбора картинки для отправки в чат
    @IBAction func takeImage(_ sender: Any) {
    }
    
    
    @IBOutlet weak var messageField: UITextField!
    
    //Описание функции нажатия на кнопку отправить сообщение
    @IBAction func sendMessage(_ sender: Any) {
        sendMessageToChat()
    }
    
    func sendMessageToChat() {
        if messageField.text != "" {
            newMessage.message = messageField.text!
            chatService.sendMessage(withData: [Constants.DBStruct.Message.message : newMessage.message])
            view.endEditing(true)
            messageField.text = ""
            self.chatList.reloadData()
        } else {
            showAlert(text: "Введите сообщение")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = chatList.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! ChatTableViewCell
        
        if FIRAuth.auth()?.currentUser?.displayName == message[indexPath.row].author {
            //Настройка поля автор, если пользователь автор сообщения
            cell.authorLabel.isHidden = true
            cell.meAuthor.isHidden = false
            cell.meAuthor.text = message[indexPath.row].author
            //Настройка поля сообщение, если пользователь автор сообщения
            cell.messageLabel.isHidden = true
            cell.myMessageLabel.isHidden = false
            cell.myMessageLabel.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            cell.myMessageLabel.text = message[indexPath.row].message
            
        }
            //Настройка ячейки, если юзер не автор сообщения
        else if FIRAuth.auth()?.currentUser?.displayName != message[indexPath.row].author {
            cell.meAuthor.isHidden = true
            cell.authorLabel.isHidden = false
            cell.authorLabel.text = message[indexPath.row].author
            
            cell.messageLabel.isHidden = false
            cell.myMessageLabel.isHidden = true
            cell.messageLabel.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.messageLabel.text = message[indexPath.row].message

        }
        cell.messageLabel.layer.cornerRadius = 10
        cell.myMessageLabel.layer.cornerRadius = 10
        return cell
    }

}

extension ChatViewController: GetChatDelegate {
    func didReciveMessage(message: [Message]) {
        self.message = message
        self.chatList.reloadData()
        let indexPath = NSIndexPath(row: self.message.count-1, section: 0)
        self.chatList.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    func getReciveImage(image: UIImage, indexPath: Int) {
        self.message[indexPath].image = image
    }
    func didFaildWithError(error: Error) {
        //
    }
    
    func setImagePathToMessage(imagePath: String) {
        self.newMessage.imagePath = imagePath
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //guard let text = messageField.text else { return true }
//        view.endEditing(true)
//        //let data = [Constants.DBStruct.Message.message: text]
//        self.chatService.sendMessage(withData: [Constants.DBStruct.Message.message : newMessage.message,
//                                           Constants.DBStruct.Message.image: newMessage.imagePath!])
//        messageField.text = ""
//        self.chatList.reloadData()
        sendMessageToChat()
        return true
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addPhoto(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            picker.sourceType = UIImagePickerControllerSourceType.camera
//        } else {
//            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        }
//        
//        present(picker, animated: true, completion:nil)
    }
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String : Any]) {
//        let picData = info[UIImagePickerControllerOriginalImage] as? UIImage
//        let imageData = UIImageJPEGRepresentation(picData!, 0.5)
//        let imagePath = "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
//        
//        chatService.sendImageToStorage(imageData: imageData!, imagePath: imagePath)
//        picker.dismiss(animated: true, completion:nil)
//    }
}




