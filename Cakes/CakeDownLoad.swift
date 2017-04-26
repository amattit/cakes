//
//  File.swift
//  Cakes
//
//  Created by Mikhail Seregin on 05.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation
import Firebase

protocol CakeServiceDelegate {
  func didReciveCake(cake: [Cake])
  func didFaildWithError(error: Error)
  func didReciveImage(image: UIImage, indexPath: Int)
}

class CakeServise: NSObject {
  var delegate: CakeServiceDelegate?
  var refHandle: FIRDatabaseHandle?
    var refImages: FIRDatabaseHandle?
  var ref:FIRDatabaseReference?
  var cake = [Cake]()
    var imagePath:[String] = []
  
  func getCakes1() {
    ref = FIRDatabase.database().reference()
    refHandle = ref?.child(Constants.DBStruct.rootCakes).observe(.childAdded, with: { (snapshot) in
      let cakeSnapshot = snapshot.value as! [String:String]
//        let key = self.ref?.child("cakes").key
//        self.refImages = self.ref?.child("cakes/\(key)/images").observe(.childAdded, with: { (images) in
//            self.imagePath.removeAll()
//            let imgSnapshot = images.value as! [String:String]
//            self.imagePath.append(imgSnapshot["name"]!)
//        })
        self.cake.append(Cake(name: cakeSnapshot["name"]!, prise: cakeSnapshot["prise"]!, imagePath: [""], category: cakeSnapshot["category"]!/*, miniImagePath: cakeSnapshot[""]!*/))
        self.delegate?.didReciveCake(cake: self.cake)
    })
  }
  
    func getCakes() {
        ref = FIRDatabase.database().reference()
        refHandle = ref?.child(Constants.DBStruct.rootCakes).observe(.childAdded, with: { (snapshot) in
            let cakeSnapshot = snapshot.value as! [String:AnyObject]
            if cakeSnapshot["images"] != nil {
                let img = cakeSnapshot["images"] as! [String:AnyObject]
                self.imagePath.removeAll()
                for img in img.values {
                    let tmp = img as! [String:String]
                    self.imagePath.append(tmp["name"]!)
                }
            }
            self.cake.append(Cake(name: cakeSnapshot["name"]! as? String, prise: cakeSnapshot["prise"]! as? String, imagePath: self.imagePath, category: cakeSnapshot["category"]! as? String/*, miniImagePath: cakeSnapshot[""]!*/))
            self.delegate?.didReciveCake(cake: self.cake)
        })
    }

  func getImageForCake(imagePath: String, indexPath: Int) {
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
              self.delegate?.didReciveImage(image: pic!, indexPath:indexPath)
            }
          }
        }
      }
    }
  }

}

