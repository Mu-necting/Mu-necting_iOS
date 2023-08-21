//
//  ArchivePickViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class ArchivePickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var latestBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    
    var images = [UIImage(named: "album1"), UIImage(named: "album2"), UIImage(named: "album3")]
    var selectedIndices: Set<Int> = []
    
    var isLatestSorted = true // 최신순으로 정렬되었는지 여부
    var buttonNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionview 초기화
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10 // 아이템들 사이의 간격
        layout.minimumLineSpacing = 10 // 행 사이의 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 섹션 주위 여백
        layout.itemSize = CGSize(width: 100, height: 100) // 각 아이템의 크기
        collectionView.collectionViewLayout = layout
           
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //eMode를 .view로 초기화
        eMode = .view
        
        // 최신순 초기 설정
        if isLatestSorted {
            latestBtn.setTitle("최신순", for: .normal)
            latestBtn.setImage(nil, for: .normal)
            images.sort { image1, image2 in
                // 최신순으로 정렬 비교 로직
                return true // 최신순으로 정렬되었다고 가정
            }
            collectionView.reloadData()
            isLatestSorted = false
        }
        
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
                
                if isLatestSorted {
                    latestBtn.setTitle("최신순", for: .normal)
                    latestBtn.setImage(nil, for: .normal)
                } else {
                    latestBtn.setTitle("인기순", for: .normal)
                    latestBtn.setImage(nil, for: .normal)
                }
                
                editBtn.setImage(UIImage(named: "edit"), for: .normal)
                
                collectionView.allowsMultipleSelection = false
                
            case .select:
                latestBtn.setImage(UIImage(named: "trash"), for: .normal)
                latestBtn.setTitle(nil, for: .normal)
                editBtn.setImage(UIImage(named: "cancel"), for: .normal)
                editBtn.setTitle(nil, for: .normal)
                
                collectionView.allowsMultipleSelection = true
            }
        }
    }
       
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
       
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system) // UIButton 초기화
        button.setImage(UIImage(systemName: "trash"), for: .normal) // 이미지 설정
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(didDeleteButtonClicked(_:)), for: .touchUpInside) // 동작 추가
        return button
    }()
       
    @objc func didDeleteButtonClicked(_ sender: UIButton) {
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
       
    @IBAction func editButtonTapped(_ sender: UIButton) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! ArchivePickCollectionViewCell
           
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
            if isLatestSorted {
                latestBtn.setTitle("최신순", for: .normal)
                latestBtn.setImage(nil, for: .normal)
                
                images.sort { image1, image2 in
                    // 최신순으로 정렬 비교 로직
                    return true // 최신순으로 정렬되었다고 가정
                }
                
                collectionView.reloadData()
                
            } else {
                latestBtn.setTitle("인기순", for: .normal)
                latestBtn.setImage(nil, for: .normal)

                images.sort { image1, image2 in
                    // 최신순으로 정렬 비교 로직
                    return true // 최신순으로 정렬되었다고 가정
                }
                
                collectionView.reloadData()
            }
        }
        
        isLatestSorted = !isLatestSorted
    }
    
    //<뒤로가기 버튼 구현>
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        
    }
    
    //필터 버튼 구현
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        let filterPopUpVC = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "FilterPopUp") as! ArchiveFilterPopUpViewController
        
        filterPopUpVC.modalPresentationStyle = .overCurrentContext
        filterPopUpVC.modalTransitionStyle = .crossDissolve
        
        self.present(filterPopUpVC, animated: true, completion: nil)
    }
    
}

