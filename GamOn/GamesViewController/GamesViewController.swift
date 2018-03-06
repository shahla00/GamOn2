//
//  Games.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/19/18.
//

import UIKit
import Contacts

class GamesViewController: UICollectionViewController {
    let games = Games()
    
    ///
    ///
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UINib(nibName: "GameCell", bundle: Bundle.main), forCellWithReuseIdentifier: "GameCell")
        
        // Load categories
        games.clearCatArray()
        games.requestCategories { [weak self] () in
            self?.collectionView?.reloadData()
        }
    }
    
    ///
    ///
    ///
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    ///
    ///
    ///
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.catArray.count
    }
    
    ///
    ///
    ///
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
        if let cell = cell as? GameCell {
            cell.title.text = games.catArray[indexPath.row]
            cell.backgroundColor = .specialPurple
        }
        return cell
    }
}
