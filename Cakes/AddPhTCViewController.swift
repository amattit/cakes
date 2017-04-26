//
//  AddPhTCViewController.swift
//  Cakes
//
//  Created by Михаил Серёгин on 15.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//
import Firebase
import UIKit

class AddPhTCViewController: UIViewController {
    enum SelectedPhotoTag: Int {
        case first
        case second
        case third
        case fourth
    }

    @IBAction func next(_ sender: UIBarButtonItem) {
        if img! != [] {
            performSegue(withIdentifier: "addCake", sender: self)
        } else {
            showAlert(text: "Добавте хотя бы одну фотографию")
        }
    }
    @IBOutlet weak var adPhoto: UIImageView!
    @IBOutlet weak var addPhoto2: UIImageView!
    @IBOutlet weak var addPhoto3: UIImageView!
    @IBOutlet weak var addPhoto4: UIImageView!
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        switch sender.tag {
        case SelectedPhotoTag.first.rawValue:
            isActiveFirstPhoto = true
            isActiveSecondPhoto = false
            isActiveThirdPhoto = false
            isActiveFourthPhoto = false
            selectPhotoSource()
        case SelectedPhotoTag.second.rawValue:
            isActiveFirstPhoto = false
            isActiveSecondPhoto = true
            isActiveThirdPhoto = false
            isActiveFourthPhoto = false
            selectPhotoSource()
        case SelectedPhotoTag.third.rawValue:
            isActiveFirstPhoto = false
            isActiveSecondPhoto = false
            isActiveThirdPhoto = true
            isActiveFourthPhoto = false
            selectPhotoSource()
        case SelectedPhotoTag.fourth.rawValue:
            isActiveFirstPhoto = false
            isActiveSecondPhoto = false
            isActiveThirdPhoto = false
            isActiveFourthPhoto = true
            selectPhotoSource()
        default: break
        }
    }
    
    
    var isActiveFirstPhoto: Bool = false
    var isActiveSecondPhoto: Bool = false
    var isActiveThirdPhoto: Bool = false
    var isActiveFourthPhoto: Bool = false
    var imagePath:[String]?
    var cake: Cake? = nil
    var img:[Data]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: "auth", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCake" {
            let dc = segue.destination as! AddCakeViewController
            dc.images = img!
        }
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     */
    deinit {
        img?.removeAll()
    }
    
}

// MARK: - ImagePickerController
extension AddPhTCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPhotoSource() {
        let selectPhotoSourse = UIAlertController(title: "Фото", message: nil, preferredStyle: .actionSheet)
        selectPhotoSourse.addAction(UIAlertAction(title: "Фотокамера", style: .default, handler: { (UIAlertAction) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion:nil)
        }))
        selectPhotoSourse.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: { (UIAlertAction) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion:nil)
        }))
        self.present(selectPhotoSourse, animated: true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        func selectPhoto() -> Data {
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            let imageData = UIImageJPEGRepresentation(image!, 0.5)
            self.img?.append(imageData!)
            return imageData!
        }
        
        
        
        if isActiveFirstPhoto == true {
            let data = selectPhoto()
            adPhoto.image = UIImage(data: data)
        }
        if isActiveSecondPhoto == true {
            let data = selectPhoto()
            addPhoto2.image = UIImage(data: data)
        }
        if isActiveThirdPhoto == true {
            let data = selectPhoto()
            addPhoto3.image = UIImage(data: data)
        }
        if isActiveFourthPhoto == true {
            let data = selectPhoto()
            addPhoto4.image = UIImage(data: data)
        }
        picker.dismiss(animated: true, completion:nil)
    }

}
