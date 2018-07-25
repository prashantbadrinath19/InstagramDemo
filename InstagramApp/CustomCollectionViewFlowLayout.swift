//
//  CustomCollectionViewFlowLayout.swift
//  FirebaseUsers
//
//  Created by Prashant Badrinath on 06/06/18.
//  Copyright © 2018 Prashant Badrinath. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    override var itemSize: CGSize
    {
        set {}
        get
        {
            let numberOfColumns: Int = 3
            let itemWidth = CGFloat((Int((collectionView?.frame.width)!) - (numberOfColumns - 1)) / numberOfColumns)
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
}
