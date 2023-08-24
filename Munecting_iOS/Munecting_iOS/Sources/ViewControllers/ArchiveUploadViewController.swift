//
//  ArchiveUploadViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit
import Alamofire
import AlamofireImage

class ArchiveUploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var latestBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var images = [UIImage(named: "album1"), UIImage(named: "album2"), UIImage(named: "album3")]
    //var images: [ArchiveDetail] = []
    //var musicData: [ArchiveDetail] = []
    var selectedIndices: Set<Int> = []
    var titles  = ["Journey", "아까워", "좋아해줘"]
    var genres = ["힙합", "힙합", "락"]
    var artists = ["재지팩트(Jazzyfact)", "재지팩트(Jazzyfact)", "검정치마"]
    
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
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        // Initialize the view
        eMode = .view
        
        // Initialize images and sorting
        sortImages(isLatest: true)
        
        loadProfileImage()
        loadUsername()
        
        // 음악 데이터를 API에서 가져옵니다.
        fetchMusicData()
        
    }
    
    func fetchMusicData() {
        ArchivePickService.ArchivePickDetail(pickId: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pickDetail):
                if let archiveDetail = pickDetail as? ArchiveDetail {
                    ArchiveDetailManager.shared.archiveDetail = archiveDetail
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String { print(message) }
           /* case .pathErr, .serverErr, .networkFail:
                print("Error in fetchMusicData")
            case .requestErr(let msg):
                if let message = msg as? String { print(message) }*/
            case .pathErr:
                print("pathErr in fetchMusicData")
            case .serverErr:
                print("serverErr in fetchMusicData")
            case .networkFail:
                print("networkFail in fetchMusicData")
            }
        }
    }
    
    func loadProfileImage() {
        if let profileImageURL = UserManager.shared.getUser()?.profileImage {
            // Alamofire를 사용하여 프로필 이미지 다운로드
            AF.request(profileImageURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    self.profileImg.image = image
                case .failure(let error):
                    print("Error downloading profile image: \(error)")
                }
            }
        }
    }
       
    func loadUsername() {
        if let username = UserManager.shared.getUser()?.userName {
            nicknameLbl.text = username
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
                
                collectionView.allowsMultipleSelection = false
                
            case .select:
                collectionView.allowsMultipleSelection = true
            }
        }
    }
       
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
       
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
        
        eMode = .view
        if eMode == .select {
            latestBtn.setImage(UIImage(named: "trash"), for: .normal)
            editBtn.setImage(UIImage(named: "cancel"), for: .normal)
            
        } else {
            setButtonTitles()
            editBtn.setImage(UIImage(named: "edit"), for: .normal)
        }
    }
       
    @IBAction func editButtonTapped(_ sender: UIButton) {
        eMode = eMode == .view ? .select : .view
        collectionView.reloadData()
        
        if eMode == .select {
            latestBtn.setImage(UIImage(named: "trash"), for: .normal)
            editBtn.setImage(UIImage(named: "cancel"), for: .normal)
            
        } else {
            setButtonTitles()
            editBtn.setImage(UIImage(named: "edit"), for: .normal)
        }
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
    /*
    //서버에서 이미지 받아오기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! ArchivePickCollectionViewCell
        
        if indexPath.row < images.count {
            let archiveDetail = images[indexPath.row]
            let coverImgURL = archiveDetail.coverImg
            
            cell.displayCoverImage(fromURL: coverImgURL) // API에서 받아온 coverImg 표시
        }

        // Update cell selection status
        cell.isSelected = dictionarySelectedIndexPath[indexPath] ?? false

        return cell
    }
    */
    
    //상세보기 페이지 이동 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch eMode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            // Handle view mode action
            
            let modalViewController = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "UploadDetailView") as! ArchiveUploadDetailViewController
            
            modalViewController.modalPresentationStyle = self.modalPresentationStyle
                
            // 선택한 이미지를 모달 뷰 컨트롤러에 전달
            if let Image = images[indexPath.row] {
                modalViewController.passAlbumImg = Image
            }
            modalViewController.titleText = titles[indexPath.row]
            modalViewController.singerText = artists[indexPath.row]
            modalViewController.genreText = "Genre: " + genres[indexPath.row]
            
            present(modalViewController, animated: true, completion: nil)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    //<최신순, 인기순 정렬>
    @IBAction func latestButtonTapped(_ sender: UIButton) {
        if eMode == .select {
            didDeleteButtonClicked(sender) // 선택한 항목들을 삭제하는 함수 호출
        } else {
            sortImages(isLatest: !isLatestSorted)
        }
    }
    
    private func setButtonTitles() {
        latestBtn.setImage(isLatestSorted ? UIImage(named: "popular") : UIImage(named: "latest"), for: .normal)
    }
        
    private func sortImages(isLatest: Bool) {
        isLatestSorted = isLatest
        setButtonTitles()
        
        images.sort { image1, image2 in
            // Sorting logic based on isLatest
            return true // Sorting result (latest or popular)
        }
        
        collectionView.reloadData()
    }
    
    //<뒤로가기 버튼 구현>
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            let sb = UIStoryboard(name: "Home", bundle: nil)
            guard let viewController = sb.instantiateViewController(identifier: "PageViewController") as? PageViewController else {return}
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController, animated: true)
        }
    }
    
    @IBAction func settingBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            let SettingVC = UIStoryboard(name: "Setting", bundle: nil)
                .instantiateViewController(withIdentifier: "SettingVC")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(SettingVC, animated: true)
        }
    }
    
    //필터 버튼 구현
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        let filterPopUpVC = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "FilterPopUp") as! ArchiveFilterPopUpViewController
        
        filterPopUpVC.modalPresentationStyle = .overCurrentContext
        filterPopUpVC.modalTransitionStyle = .crossDissolve
        
        self.present(filterPopUpVC, animated: true, completion: nil)
    }
}
