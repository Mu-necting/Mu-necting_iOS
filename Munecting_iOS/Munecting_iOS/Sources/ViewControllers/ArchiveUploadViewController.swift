//
//  ArchiveUploadViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class ArchiveUploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var latestBtn: UIButton!
    @IBOutlet weak var popularBtn: UIButton!
    
    var images = [UIImage(named: "album1"), UIImage(named: "album2"), UIImage(named: "album3")]
    var selectedIndices: Set<Int> = []
    
    var isLatestSorted = true // 최신순으로 정렬되었는지 여부
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionview 초기화
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10 // 아이템들 사이의 간격
        layout.minimumLineSpacing = 10 // 행 사이의 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 섹션 주위 여백
        layout.itemSize = CGSize(width: 100, height: 100) // 각 아이템의 크기
        //layout.textAlignment = .left // 아이템을 왼쪽 정렬
        collectionView.collectionViewLayout = layout
           
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // eMode를 .view로 초기화
        eMode = .view
        
        //정렬 초기화 (최신순 기본 선택)
        latestBtn.isEnabled = !isLatestSorted
        popularBtn.isEnabled = isLatestSorted
        
        // 최신순 버튼의 글씨 색을 설정
        latestBtn.setTitleColor(.gray, for: .disabled)
                
        // 인기순 버튼의 글씨 색을 설정
        popularBtn.setTitleColor(.black, for: .normal)
        
    }
    
    //<셀 선택 삭제 기능>
    enum Mode {
        case view
        case select
    }
       
    var eMode: Mode = .view {
        didSet {
            switch eMode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                   
                editBtn.image = UIImage(named: "edit")
                backBtn.image = UIImage(named: "arrow")
                //backBtn.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"))
                
                collectionView.allowsMultipleSelection = false
                
            case .select:
                editBtn.image = UIImage(named: "cancel")
                backBtn.image = UIImage(named: "trash")
                collectionView.allowsMultipleSelection = true
            }
        }
    }
       
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
       
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
    }()
       
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
                
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
                
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            images.remove(at: i.item)
        }
        
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
        collectionView.reloadData()
    }
       
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        eMode = eMode == .view ? .select : .view
        collectionView.reloadData() // 추가된 부분
        
        // 버튼 이미지 변경
        /*if eMode == .select {
            editBtn.title = "취소"
        } else {
            editBtn.image = UIImage(named: "edit") // 기본 이미지 이름 사용
        }*/
    }
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //셀에 이미지 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! ArchiveUploadCollectionViewCell
           
        cell.albumImg.image = images[indexPath.row]
           
        // Update cell selection status
        cell.isSelected = dictionarySelectedIndexPath[indexPath] ?? false
           
        return cell
    }
    
    //상세보기 페이지 이동 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch eMode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            // Handle view mode action
            
            let modalViewController = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "ArchiveDetailViewController") as! ArchiveDetailViewController
            
            modalViewController.modalPresentationStyle = self.modalPresentationStyle
                
            // 선택한 이미지를 모달 뷰 컨트롤러에 전달
            if let Image = images[indexPath.row] {
                modalViewController.passAlbumImg = Image
            }

            present(modalViewController, animated: true, completion: nil)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    //<최신순, 인기순 정렬>
    @IBAction func latestButtonTapped(_ sender: UIButton) {
        isLatestSorted = true
        
        images.sort { image1, image2 in
            // 최신순으로 정렬 비교 로직
            return true // 최신순으로 정렬되었다고 가정
        }
        
        // 최신순 버튼의 글씨 색을 설정
        latestBtn.setTitleColor(.gray, for: .disabled)
                
        // 인기순 버튼의 글씨 색을 설정
        popularBtn.setTitleColor(.black, for: .normal)
        
        latestBtn.isEnabled = !isLatestSorted
        popularBtn.isEnabled = isLatestSorted
        
        collectionView.reloadData()
    }
        
    @IBAction func popularButtonTapped(_ sender: UIButton) {
        isLatestSorted = false
        
        images.sort { image1, image2 in
            // 인기순으로 정렬 비교 로직
            return true // 인기순으로 정렬되었다고 가정
        }
        
        // 최신순 버튼의 글씨 색을 설정
        latestBtn.setTitleColor(.black, for: .normal)
                
        // 인기순 버튼의 글씨 색을 설정
        popularBtn.setTitleColor(.gray, for: .disabled)
            
        latestBtn.isEnabled = !isLatestSorted
        popularBtn.isEnabled = isLatestSorted
        
        collectionView.reloadData()
    }
    
    //<뒤로가기 버튼 구현>
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        // 버튼 이미지 변경
        if eMode == .select {
            //backBtn.image = UIImage(named: "heart")
            var deleteNeededIndexPaths: [IndexPath] = []
                    
            for (key,value) in dictionarySelectedIndexPath {
                if value {
                    deleteNeededIndexPaths.append(key)
                }
            }
                    
            for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
                images.remove(at: i.item)
            }
            
            collectionView.deleteItems(at: deleteNeededIndexPaths)
            dictionarySelectedIndexPath.removeAll()
            collectionView.reloadData()
            
            eMode = .view
            
        } else {
            //backBtn.image = UIImage(named: "arrow") // 기본 이미지 이름 사용
        }
        
    }
}
