//
//  GetChat.swift
//  Cakes
//
//  Created by Михаил Серёгин on 11.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation
import Firebase

protocol GetChatDelegate {
    func didReciveMessage(message: [Message])
    func didFaildWithError(error: Error)
    func getReciveImage(image: UIImage, indexPath: Int)
    func setImagePathToMessage(imagePath: String)
}

class GetChat {
    var delegate: GetChatDelegate?
    var ref: FIRDatabaseReference?
    var refMessage: FIRDatabaseHandle?
    var message = [Message]()
    var storageRef: FIRStorageReference!
    
//    func getChat() {
//        ref = FIRDatabase.database().reference()
//        refMessage = ref?.child(Constants.DBStruct.chat).observe(.value, with: { (snapshot) in
//            let messageSnapshot = snapshot.children
//            while let message = messageSnapshot.nextObject() as? FIRDataSnapshot {
//                let messageTMP = message.value as! [String:String]
//                self.message.append(Message(message: messageTMP[Constants.DBStruct.Message.message]!, author: messageTMP[Constants.DBStruct.Message.author]!, image: messageTMP[Constants.DBStruct.Message.image]))
//            }
//            self.delegate?.didReciveMessage(message: self.message)
//        })
//    }
    
    func getChatUpdate() {
        ref = FIRDatabase.database().reference()
        refMessage = ref?.child(Constants.DBStruct.chat).observe(.childAdded, with: { (snapshot) in
            let messageSnapshot = snapshot.value as! [String: String]
            self.message.append(Message(message: messageSnapshot[Constants.DBStruct.Message.message]!, author: messageSnapshot[Constants.DBStruct.Message.author]!, image: messageSnapshot[Constants.DBStruct.Message.image]))
            self.delegate?.didReciveMessage(message: self.message)
        })
    }
    
    func getImageForMessage(imagePath: String, indexPath: Int){
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if imagePath != "" {
                if (imagePath.hasPrefix("gs://")) {
                    FIRStorage.storage().reference(forURL: imagePath).data(withMaxSize: INT64_MAX) { (data, error) in
                        if let error = error {
                            print(error)
                            self.delegate?.didFaildWithError(error: error)
                            return
                        }
                        DispatchQueue.main.async {
                            print("Запрос картинки:\(imagePath)")
                            let pic = UIImage.init(data: data!)
                            self.delegate?.getReciveImage(image: pic!, indexPath:indexPath)
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.DBStruct.Message.author] = FIRAuth.auth()?.currentUser?.displayName
        self.ref?.child(Constants.DBStruct.chat).childByAutoId().setValue(mdata)
        print(mdata)
    }
    
    func sendImageToStorage(imageData: Data, imagePath:String) {
        storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath)
            .put(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                self.delegate?.setImagePathToMessage(imagePath: self.storageRef.child((metadata?.path)!).description)
        }
    }

}
