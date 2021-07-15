//
//  ViewController.swift
//  TravelSites
//
//  Created by eyal avisar on 13/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cityLabel = UILabel()
    var chosenSitesLabel = UILabel() //add observers
    
    var model = SiteModel().getSiteModel()
    var myCollectionView:UICollectionView?
    var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarAppearance()
        addBackgroundViews()
        addCollectionView()
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
    func setNavBarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .blue
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    
    func addBackgroundViews() {
        var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.4)
        let blueView = UIView(frame: frame)
        blueView.backgroundColor = .blue
        
        view.addSubview(blueView)
        
        frame = CGRect(x: 10, y: blueView.bounds.height * 0.5, width: blueView.bounds.width * 0.2, height: blueView.bounds.height * 0.1)
        
        cityLabel = UILabel(frame: frame)
        
        cityLabel.textColor = .white
        cityLabel.text = "City"
        blueView.addSubview(cityLabel)
        
        frame = CGRect(x: blueView.bounds.width * 0.8 - 10, y: blueView.bounds.height * 0.5, width: blueView.bounds.width * 0.2, height: blueView.bounds.height * 0.1)
        
        chosenSitesLabel = UILabel(frame: frame)
        chosenSitesLabel.textColor = .white
        chosenSitesLabel.text = "0/0"
        chosenSitesLabel.textAlignment = .right
        blueView.addSubview(chosenSitesLabel)
        
        frame = CGRect(x: 0, y: view.bounds.height * 0.4, width: view.bounds.width, height: view.bounds.height * 0.6)
        let greenView = UIView(frame: frame)
        greenView.backgroundColor = .green
        
        view.addSubview(greenView)
        
    }
    
    func addCollectionView() {
        let frame = CGRect(x: 0, y: view.bounds.height * 0.3, width: view.bounds.width, height: view.bounds.height * 0.7)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: view.bounds.width / 2.3, height: view.bounds.height * 0.7 / 3.3)
        
        myCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        myCollectionView?.register(SiteCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = .none
        view.addSubview(myCollectionView ?? UICollectionView())
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let myCell = cell as! SiteCell
        
        if model[indexPath.row].isCheck {
            myCell.toggleCurtain(isChecked: model[indexPath.row].isCheck)
            myCollectionView?.reloadData()
            model[indexPath.row].isCheck = false
        }
        else {
            myCollectionView?.reloadData()
            myCell.toggleCurtain(isChecked: model[indexPath.row].isCheck)
//            checkCell(cell: cell)
            model[indexPath.row].isCheck = true
        }
    }
    
    func checkCell(cell: UICollectionViewCell) {
        maskView.removeFromSuperview()
        maskView.frame = cell.contentView.frame
        cell.addSubview(maskView)
        let checkmarkImageView = UIImageView(frame: CGRect(x: maskView.bounds.width - 20, y: 0, width: 20, height: 20))
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        maskView.addSubview(checkmarkImageView)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! SiteCell
        
        setCellVisuals(cell: cell, isChecked: model[indexPath.row].isCheck)
        
        cell.backgroundColor = .white
        cell.siteLabel.text = model[indexPath.row].name
        cell.imageView.image = model[indexPath.row].image
        
        if cityLabel.text != model[indexPath.row].city {
            cityLabel.text = model[indexPath.row].city
        }
        
        return cell
    }
    
    func setCellVisuals(cell: UICollectionViewCell, isChecked: Bool) {
        if !isChecked {
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        }
        else {
            cell.layer.shadowColor = .none
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 0
            cell.layer.shadowOpacity = 0
            cell.layer.masksToBounds = false
//            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        }
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
    }
}

