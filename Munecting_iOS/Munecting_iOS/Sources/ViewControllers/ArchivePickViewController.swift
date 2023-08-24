//
//  ArchivePickViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit
import Alamofire
import AlamofireImage

class ArchivePickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var latestBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    //var images = [UIImage(named: "album1"), UIImage(named: "album2"), UIImage(named: "album3")]
    //var images: [ArchiveDetail] = []
    //var musicData: [ArchiveDetail] = []
    var images: [UIImage] = []
    var titles: [String] = []
    var genres: [String] = []
    var artists: [String] = []
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
        
        // 더미 음악 데이터를 가져오는 함수 호출
        getDummyMusic()
        
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
    
    //DummyMusic 갖고오기
    func getDummyMusic(){
        
        let dummyMusic1: AroundMusic = AroundMusic(
            name: "Attention",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/100x100bb.jpg",
            genre: "pop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/b5/32/d4/b532d45b-0e4d-6bf3-d7b5-e02007877318/mzaf_10109990520611630125.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=6QYcd7RggNU",
            replyCnt: 0,
            archiveId: 0,
            artist: "Charlie Puth",
            pickCnt: 0)
        
        let dummyMusic2: AroundMusic = AroundMusic(
            name: "Attention",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg",
            genre: "kpop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=o8RkbHv2_a0",
            replyCnt: 0,
            archiveId: 0,
            artist: "NewJeans",
            pickCnt: 0)
        
        let dummyMusic3: AroundMusic = AroundMusic(
            name: "Sanso (Interlude)",
            coverImg: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/76/bc/37/76bc37d2-283d-f252-716e-183c268b8a87/197189280801.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fc/05/e9/fc05e999-0e4f-2a28-e21d-3fd55a671208/mzaf_13793805966112651018.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=JaJCPjd4iE8",
            replyCnt: 0,
            archiveId: 0,
            artist: "Beenzino",
            pickCnt: 0)
        
        let dummyMusic4: AroundMusic = AroundMusic(
            name: "모든 것이 꿈이었네 (It Was All a Dream)",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/b5/9c/27/b59c2792-bb97-2a40-f482-c6d5b3ae1cea/196626603180.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/79/97/b3/7997b3fd-b8b8-0540-787a-0ef0988e807c/mzaf_6188522879362145428.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=xICSRpVzATI",
            replyCnt: 0,
            archiveId: 0,
            artist: "250",
            pickCnt: 0)
        
        let dummyMusic5: AroundMusic = AroundMusic(
            name: "Slay",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/02/6a/99/026a998e-835f-81a9-d5e5-f0fbf091caf7/cover-C_JAMM_NEW.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/2c/7d/fc/2c7dfcb8-4c6b-f691-9c76-8fe499c3d6b7/mzaf_3230752141782334299.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08",
            replyCnt: 0,
            archiveId: 0,
            artist: "C JAMM",
            pickCnt: 0)
        
        let dummyMusic6: AroundMusic = AroundMusic(
            name: "Super Shy",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/63/e5/e2/63e5e2e4-829b-924d-a1dc-8058a1d69bd4/196922462702_Cover.jpg/100x100bb.jpg",
            genre: "kpop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/98/66/db/9866dbb4-6e6f-eedd-ea1c-4832542b8f3e/mzaf_1940197871229851903.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=ArmDp-zijuc",
            replyCnt: 0,
            archiveId: 0,
            artist: "NewJeans",
            pickCnt: 0)
        
        let dummyMusics: [AroundMusic] = [dummyMusic1, dummyMusic2, dummyMusic3, dummyMusic4, dummyMusic5, dummyMusic6]
        
        // 더미 음악 데이터에서 coverImg URL을 사용하여 UIImage 배열 생성
        for dummyMusic in dummyMusics {
            if let coverImgURL = URL(string: dummyMusic.coverImg),
               let imageData = try? Data(contentsOf: coverImgURL),
               let coverImage = UIImage(data: imageData) {
                
                images.append(coverImage)
                titles.append(dummyMusic.name) // 음악 이름 배열에 추가
                genres.append(dummyMusic.genre) // 장르 배열에 추가
                artists.append(dummyMusic.artist) // 아티스트 배열에 추가
            }
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
                
                /*if isLatestSorted {
                    latestBtn.setTitle("최신순", for: .normal)
                    latestBtn.setImage(nil, for: .normal)
                } else {
                    latestBtn.setTitle("인기순", for: .normal)
                    latestBtn.setImage(nil, for: .normal)
                }
                
                editBtn.setImage(UIImage(named: "edit"), for: .normal)*/
                
                collectionView.allowsMultipleSelection = false
                
            case .select:
                /* latestBtn.setImage(UIImage(named: "trash"), for: .normal)
                latestBtn.setTitle(nil, for: .normal)
                editBtn.setImage(UIImage(named: "cancel"), for: .normal)
                editBtn.setTitle(nil, for: .normal) */
                
                collectionView.allowsMultipleSelection = true
            }
        }
    }
       
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
       
    /*lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system) // UIButton 초기화
        //button.setImage(UIImage(systemName: "trash"), for: .normal) // 이미지 설정
        //button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(didDeleteButtonClicked(_:)), for: .touchUpInside) // 동작 추가
        return button
    }()*/
       
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! ArchivePickCollectionViewCell
           
        cell.albumImg.image = images[indexPath.row]
           
        // Update cell selection status
        cell.isSelected = dictionarySelectedIndexPath[indexPath] ?? false
           
        return cell
    }
    
    //서버에서 이미지 받아오기
    /*func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! ArchivePickCollectionViewCell
        
        if indexPath.row < images.count {
            let archiveDetail = images[indexPath.row]
            let coverImgURL = archiveDetail.coverImg
            
            cell.displayCoverImage(fromURL: coverImgURL) // API에서 받아온 coverImg 표시
        }

        // Update cell selection status
        cell.isSelected = dictionarySelectedIndexPath[indexPath] ?? false

        return cell
    }*/
    
    //상세보기 페이지 이동 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch eMode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            // 상세보기 모드 처리
            
            let modalViewController = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "ArchiveDetailViewController") as! ArchiveDetailViewController
            
            modalViewController.modalPresentationStyle = self.modalPresentationStyle
            
            // 선택한 이미지를 모달 뷰 컨트롤러에 전달
            modalViewController.passAlbumImg = images[indexPath.row]
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
        //self.dismiss(animated: true) {
            let SettingVC = UIStoryboard(name: "Setting", bundle: nil)
                .instantiateViewController(withIdentifier: "SettingVC")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(SettingVC, animated: true)
        //}
    }
    
    //필터 버튼 구현
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        let filterPopUpVC = UIStoryboard(name: "ArchivePage", bundle: nil).instantiateViewController(withIdentifier: "FilterPopUp") as! ArchiveFilterPopUpViewController
        
        filterPopUpVC.modalPresentationStyle = .overCurrentContext
        filterPopUpVC.modalTransitionStyle = .crossDissolve
        
        self.present(filterPopUpVC, animated: true, completion: nil)
    }
    
}

