//
//  BestMunectorUITestViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//

import UIKit

class BestMunectorViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.munectingPurple
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        personBackgroundView.layer.cornerRadius = 102 / 2
        personBackgroundView.layer.masksToBounds = true
        personBackgroundView.backgroundColor = UIColor.systemYellow
        personBackgroundView.layer.masksToBounds = true
        
        secondBackgroundView.layer.cornerRadius = 90/2
        secondBackgroundView.layer.masksToBounds = true
        secondBackgroundView.backgroundColor = UIColor.systemGray4
        secondBackgroundView.layer.masksToBounds = true
        
        thirdBackgroundView.layer.cornerRadius = 90/2
        thirdBackgroundView.layer.masksToBounds = true
        thirdBackgroundView.backgroundColor = UIColor.munectingCUColor
        thirdBackgroundView.layer.masksToBounds = true
        
        
        firstPersonImageView.layer.cornerRadius = 102/2
        secondPersonImageView.layer.cornerRadius = 85/2
        thirdPersonImageView.layer.cornerRadius = 85/2
        self.configureCollectionView()
        
        
    }
    
    
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    @IBOutlet var firstPersonImageView: UIImageView!
    @IBOutlet var thirdPersonImageView: UIImageView!
    @IBOutlet var secondPersonImageView: UIImageView!
    
    @IBOutlet var personBackgroundView: UIView!
    @IBOutlet var secondBackgroundView: UIView!
    @IBOutlet var thirdBackgroundView: UIView!
    
}


extension BestMunectorViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestMunectorTestCollectionViewCell", for: indexPath) as? BestMunectorTestCollectionViewCell else {return UICollectionViewCell()}
        cell.commmonInit()
        cell.rankingLabel.text = "\(indexPath.row+4)"
 
        return cell
    }
}

extension BestMunectorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 40, height: 80)
    }
}
