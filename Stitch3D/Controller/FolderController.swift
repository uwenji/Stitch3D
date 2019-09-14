//
//  FolderController.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 9/12/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import Foundation
import UIKit

class FolderController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
//class FolderController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    let colors = [UIColor.systemIndigo, UIColor.systemTeal, UIColor.systemBlue]
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //spacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        navigationItem.title = "Library"
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        
        collectionView!.collectionViewLayout = layout
        collectionView?.backgroundColor = UIColor.systemBackground
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FolderCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.4, height: view.frame.width * 0.4)
    }
    
}

class FolderCell: BaseCell {
    
    let patternImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dividerShadow: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = view.frame.width * 0.2
        return view
    }()
    override func setupViews() {
        backgroundColor = UIColor.init(red: 16/255, green: 24/255, blue: 48/255, alpha: 0.4)
        layer.cornerRadius = self.frame.width * 0.5
        addSubview(dividerShadow)
        
        dividerShadow.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(patternImageView)
//        patternImageView.image = UIImage(named: <#T##String#>)
//        patternImageView.translatesAutoresizingMaskIntoConstraints = false
//        addConstraints(<#T##constraints: [NSLayoutConstraint]##[NSLayoutConstraint]#>)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: <#T##NSLayoutConstraint.FormatOptions#>, metrics: <#T##[String : Any]?#>, views: <#T##[String : Any]#>))
    }
}

class BaseCell: UICollectionViewCell {
//    var container:UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.systemBackground
//        view.layer.shadowColor = UIColor.systemGray6.cgColor
//        view.layer.borderColor = UIColor.systemGray6.cgColor
//        view.layer.borderWidth = 2
//        view.layer.cornerRadius = 25
//        view.layer.shadowRadius = 25
//        view.layer.shadowOffset = CGSize(width: 2, height: 2)
//        view.layer.shadowColor = UIColor.systemGray6.cgColor
//        view.layer.opacity = 1
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.systemIndigo
    }
    
}
