//
//  FiltersCollectionViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 17.03.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCell"

final class FiltersCollectionViewController: NSObject {
}

extension FiltersCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilterCell else {
            fatalError("Cannot deque a filter cell")
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.yellow.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension FiltersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size.width / 4
        return CGSize(width: size, height: size)
    }
}
