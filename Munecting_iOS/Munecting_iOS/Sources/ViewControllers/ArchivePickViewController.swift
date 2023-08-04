//
//  ArchivePickViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class ArchivePickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    let images = [UIImage(named: "album1"), UIImage(named: "album2"), UIImage(named: "album3")]
        
    // 선택한 셀의 이미지를 저장할 변수
    var selectedImage: UIImage?
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! ArchivePickCollectionViewCell
        
        cell.button.setImage(images[indexPath.row], for: .normal)
        
        return cell

    }
    
    // 셀을 선택하면 Segue를 실행하기 전에 이미지를 전달하는 prepare 메서드 구현
    /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showModal" {
                let button = sender as! UIButton
                let selectedIndex = button.tag
                selectedImage = images[selectedIndex]
                
                let destinationVC = segue.destination as! ArchivePickModalVC
                destinationVC.modalImage = selectedImage
            }
    } */
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
