//
//  CatalogViewController.swift
//  Cakes
//
//  Created by Михаил Серёгин on 09.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Firebase

class CatalogViewController: UIViewController {
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    var cake:[Cake]?
    var pirozhnoe:[Cake]?
    var capCake:[Cake]?
    var cakePops:[Cake]?
    var macarons:[Cake]?
    var beze:[Cake]?
    var zefir:[Cake]?
    
    var cakes:[Cake]?
    
    var catalog = ([Catalog(name: "cake", desc: "Торты", image: "tort"),
                    Catalog(name: "pirozhnoe", desc: "Пирожное", image: "pirozhnoe"),
                    Catalog(name: "capCake", desc: "Капкейки", image: "cupcake"),
                    Catalog(name: "cakePops", desc: "Кейкпопcы", image: "cakepops"),
                    Catalog(name: "macarons", desc: "Макаруны", image: "macarun"),
                    Catalog(name: "beze", desc: "Безе", image: "beze"),
                    Catalog(name: "zefir", desc: "Зефир", image: "zefir_3")])
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    var cakeDelegate: CakeServiceDelegate?
    var index:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //FIRDatabase.database().persistenceEnabled = true
        let cakeService = CakeServise()
        cakeService.delegate =  self
        cakeService.getCakes()
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCakeList" {
            
            let indexPath = index
            print(indexPath!)
            let dc = segue.destination as! ViewController
            if catalog[indexPath!].name == "cake" {
                dc.cake = cake!
            }
            if catalog[indexPath!].name == "pirozhnoe" {
                dc.cake = pirozhnoe!
            }
            if catalog[indexPath!].name == "capCake" {
                dc.cake = capCake!
            }
            if catalog[indexPath!].name == "cakePops" {
                dc.cake = cakePops!
            }
            if catalog[indexPath!].name == "macarons" {
                dc.cake = macarons!
            }
            if catalog[indexPath!].name == "zefir" {
                dc.cake = zefir!
            }
            if catalog[indexPath!].name == "beze" {
                dc.cake = beze!
            }
            
        }
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogItem", for: indexPath) as! CategoryCollectionViewCell
        
        
        cell.categoryImage.image = UIImage(named: catalog[indexPath.row].image)
        cell.countItems.text = String(describing: catalog[indexPath.row].count)

        cell.countView.layer.cornerRadius = 15
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath.row
        if catalog[indexPath.row].count > 0 {
            performSegue(withIdentifier: "showCakeList", sender: self)
        } else {
            showAlert(text: "В данный момент в категорию не добавлено ни одного товара")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width / 2.2
        let cellHeight = view.bounds.height / 3.0
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
    }
    
}

extension CatalogViewController: CakeServiceDelegate {
    func didReciveCake(cake: [Cake]) {
        self.cakes = cake
        
        self.cake = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "cake"
        })
        self.catalog[0].count = (self.cake?.count)!
        
        self.pirozhnoe = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "pirozhnoe"
        })
        self.catalog[1].count = (pirozhnoe?.count)!
        
        self.capCake = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "capCake"
        })
        self.catalog[2].count = (self.capCake?.count)!
        
        self.cakePops = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "cakePops"
        })
        self.catalog[3].count = (cakePops?.count)!
        
        self.macarons = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "macarons"
        })
        self.catalog[4].count = (self.macarons?.count)!
        
        self.beze = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "beze"
        })
        self.catalog[5].count = (beze?.count)!
        
        self.zefir = self.cakes?.filter({ (cake) -> Bool in
            cake.category == "zefir"
        })
        self.catalog[6].count = (self.zefir?.count)!
        
        self.categoryCollection.reloadData()
    }
    
    func didFaildWithError(error: Error) {
//        let alert = UIAlertController(title: "Что-то не так", message: error.localizedDescription, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    func didReciveImage(image: UIImage, indexPath: Int) {
//        self.cake[indexPath].image = image
//        self.cakeList.reloadData()
    }
}





