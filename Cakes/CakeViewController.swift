//
//  CakeViewController.swift
//  Cakes
//
//  Created by Михаил Серёгин on 12.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit

class CakeViewController: UIViewController {
    
    @IBOutlet weak var prise: UILabel!
    @IBOutlet weak var imageCol: UICollectionView!
    var cake: Cake? = nil
    let cakeService = CakeServise()
    var imagePath:[String?] = []
    var image:[UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePath = (cake?.imagePath)!
        cakeService.delegate = self
        prise.text = cake?.prise
        title = cake?.name
    }

    @IBAction func call(_ sender: Any) {
        let url = URL(string: "telprompt://+79031759827")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    /*
    // MARK: - Navigation
*/
}

extension CakeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! CakeViewCell
            if image.count < imagePath.count {
                cell.cakeImage.isHidden = true
                cell.activityIndicator.isHidden = false
                cell.activityIndicator.startAnimating()
                self.cakeService.getImageForCake(imagePath: self.imagePath[indexPath.row]!, indexPath: indexPath.row)
            } else {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                cell.cakeImage.isHidden = false
                cell.cakeImage.image = image[indexPath.row]
                cell.cakeImageWithoutBlur.image = image[indexPath.row]
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = imageCol.bounds.width - 10
        let cellHeight = imageCol.bounds.height - 10
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
    }
    
    
}

extension CakeViewController: CakeServiceDelegate {
    func didReciveCake(cake: [Cake]) {
        //
    }
    func didFaildWithError(error: Error) {
        //
    }
    func didReciveImage(image: UIImage, indexPath: Int){
        self.image.append(image)
        imageCol.reloadData()
    }
}

