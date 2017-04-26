//
//  ViewController.swift
//  Cakes
//
//  Created by Mikhail Seregin on 31.03.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

  @IBOutlet weak var cakeList: UICollectionView!
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    @IBAction func unwindFromCatalog(segue: UIStoryboardSegue) {}
    @IBAction func fromListToCategory(_ sender: Any) {
        performSegue(withIdentifier: "FromListToCategory", sender: self)
    }
//    @IBAction func logOut(_ sender: UIBarButtonItem) {
//        let fireBaseAuth = FIRAuth.auth()
//        do {
//            try fireBaseAuth?.signOut()
//            dismiss(animated: true, completion: nil)
//        }
//        catch let signOutError as NSError {
//            print ("Error signing out: \(signOutError.localizedDescription)")
//        }
//    }
    
  
  var cake = [Cake]()
  let cakeService = CakeServise()
    var category: Catalog?
    var index: Int?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    print(category?.name as Any)
    cakeService.delegate = self
    //cakeService.getCakes()
    
  }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ViewCake" {
            if index != nil {
                let dc = segue.destination as! CakeViewController
                //let cakes = filter ? filteredCake[index!] : cake[index!]
                dc.cake = cake[index!]
            } else {
                showAlert(text: "Не задан индекс Ячейки")
            }
        }
    }

    func showAlert(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    if filter == true {
//     return cake.count
//    } else {
    return cake.count
//    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cake", for: indexPath) as! CakeCollectionViewCell
//    let cakes = filter ? filteredCake[indexPath.row] : cake[indexPath.row]
    //print(cake[indexPath.row].category!)

    cell.priseLabel.text = cake[indexPath.row].prise
    
    if cake[indexPath.row].image == nil {
        cell.image.isHidden = true
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
      cakeService.getImageForCake(imagePath: cake[indexPath.row].imagePath.first!!, indexPath: indexPath.row)
    } else {
        cell.activityIndicator.stopAnimating()
        cell.activityIndicator.isHidden = true
      cell.image.isHidden = false
      cell.image.image = cake[indexPath.row].image
    }
    
    
    //cell.layer.masksToBounds = false
    cell.layer.borderWidth = 0.2
    cell.layer.shadowOpacity = 0.75
    cell.layer.shadowRadius = 3.0
    cell.layer.shadowOffset = CGSize.zero
    cell.layer.shouldRasterize = true
    cell.layer.cornerRadius = 15
    
    return cell
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width / 2.2
        let cellHeight = cellWidth + 30
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpasing = (view.bounds.width - (view.bounds.width / 2.2 * 2)) / 3
        return lineSpasing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = Int(indexPath.row)
        performSegue(withIdentifier: "ViewCake", sender: self)
        
    }
  
}

extension ViewController: ReloadCakeListDelegate {
  func reloadCakeList() {
    self.cakeList.reloadData()
  }
}

extension ViewController: CakeServiceDelegate {
  func didReciveCake(cake: [Cake]) {
    self.cake = cake
    self.cakeList.reloadData()
  }
  
  func didFaildWithError(error: Error) {
    let alert = UIAlertController(title: "Что-то не так", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  func didReciveImage(image: UIImage, indexPath: Int) {
    self.cake[indexPath].image = image
    self.cakeList.reloadData()
  }
}


