//
//  AddCakeViewController.swift
//  Cakes
//
//  Created by Mikhail Seregin on 01.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Photos
import Firebase

protocol ReloadCakeListDelegate: class {
  func reloadCakeList()
}

class AddCakeViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priseField: UITextField!
    @IBOutlet weak var categoryFieldText: UITextField!
  
    @IBAction func saveButton(_ sender: UIButton) {
        if nameField.text! != "" && priseField.text! != "" {
            sendCake(withData: ["name" : nameField.text!,
                                "prise":priseField.text!,
                                "category":selectedCategory!])
            print(key!)
            if key != nil {
                for imagePath in imagePath! {
                    sendCakeImages(data: ["name": imagePath], key: key!)
                }
            }
            delegate?.reloadCakeList()
            performSegue(withIdentifier: "unwindToMenu", sender: self)
        } else {
            showAlert(text: "Заполните наименование или цену торта")
        }
    }
  weak var delegate: ReloadCakeListDelegate?
  
    var ref: FIRDatabaseReference!
    var cakes: [FIRDataSnapshot]! = []
    var storageRef: FIRStorageReference!
    var images:[Data]?
    var cake: Cake? = nil
    var imagePath:[String]? = []
    var key: String?
    var categoryList = ([Catalog(name: "cake", desc: "Торты", image: "tort"),
                         Catalog(name: "pirozhnoe", desc: "Пирожное", image: "pirozhnoe"),
                         Catalog(name: "capCake", desc: "Капкейки", image: "cupcake"),
                         Catalog(name: "cakePops", desc: "Кейкпопcы", image: "cakepops"),
                         Catalog(name: "macarons", desc: "Макаруны", image: "macarun"),
                         Catalog(name: "beze", desc: "Безе", image: "beze"),
                         Catalog(name: "zefir", desc: "Зефир", image: "zefir_3"),])

    var selectedCategory:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        ref = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        selectedCategory = categoryList.first?.name
        categoryFieldText.text = categoryList.first?.desc
        categoryFieldText.inputView = pickerView
        for image in images! {
            photoToFireBase(data: image)
        }

        
    }
    
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.first) != nil {
      view.endEditing(true)
    }
    super.touchesBegan(touches, with: event)
  }
  func sendCake(withData data: [String: String]) {
    print(data)
    let key = self.ref.child("cakes").childByAutoId().key
    //self.ref.child("cakes").childByAutoId().setValue(data)
    self.ref.child("cakes").child(key).setValue(data)
    self.key = key
  }
    
    func sendCakeImages(data: [String:String], key: String) {
        let imageRef = ref.child("cakes/\(key)/images")
        imageRef.childByAutoId().setValue(data)
        //ref.child("cakes").updateChildValues(imageUpdate)
    }
    
    func photoToFireBase(data: Data) {
        let imagePath = "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath)
            .put(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                //                    let path = self.storageRef.child((metadata?.path)!).description
               self.imagePath?.append("gs://cakestore-48d3a.appspot.com\(imagePath)")
        }
    }
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddCakeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].desc
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = categoryList[row].name
        categoryFieldText.text = categoryList[row].desc
    }
}
