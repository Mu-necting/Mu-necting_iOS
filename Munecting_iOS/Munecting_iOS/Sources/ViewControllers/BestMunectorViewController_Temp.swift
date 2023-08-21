//
//  BestMunectorViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/07/31.
//

import UIKit

class BestMunectorViewController_Temp: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    var id = ["helloWorld", "뜨거운아이스커피"]
    var heart = ["80", "60"]
    var pick = ["60", "33"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    //collectionView설정
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
  
}

extension BestMunectorViewController_Temp: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestMunectorCollectionViewCell", for: indexPath) as? BestMunectorCollectionViewCell else {return UICollectionViewCell()}
        cell.userID.text = self.id[indexPath.row]
        cell.heartCount.text = self.heart[indexPath.row]
        cell.pickCount.text = self.pick[indexPath.row]
        return cell
    }
}

extension BestMunectorViewController_Temp: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 40, height: 80)
    }
}
