

import UIKit

//struct MusicSearchDataDummy{
//    let albumImage: UIImage
//    let albumTitle: String
//    let artist: String
//}

struct Music_HaveImage{
    var name: String
    var artist: String
    var coverImg: UIImage
    var musicPre: String?
}



class MusicSearchViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
//    var searchDataListDummy:[MusicSearchDataDummy] = []
    
    var searchMusicDatas: [MusicItem] = []
    var musics: [Music_HaveImage] = []
    var musicForUpload: MusicForUpload = MusicForUpload(name: "", coverImg: "", musicPre: "", artist: "")
    var musicName: String = ""
    var artist: String = ""
    var musicPull: String = ""
    var page = 1
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.searchTextField.delegate = self
        
        let tapGeture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
  
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.musics = []
        self.collectionView.reloadData()
    }
    
    //MARK: 설정 함수
    
    //IndicatorView 동작
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    //IndicatorView attatch
    private func attachActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
    }
    
    //IndicatorView detach
    private func detachActivityIndicator() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
        self.activityIndicator.removeFromSuperview()
    }
    
    //collectionView설정
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.refreshControl = refresh
    }
    
    //refreshControl 생성
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getNextPage) , for: .allEvents)
        return refreshControl
        }()
    
    //다음 page 검색 obj 함수
    @objc func getNextPage() {
        self.page = self.page + 1
        if self.page%2 == 1{
            self.page = self.page-1
            self.searchMusicWithAPI(searchKeyword: self.musicName, page: self.page)
            self.collectionView.reloadData()
        }
    }
    
    //MARK: 버튼 함수
    
    //검색 버튼 함수
    @IBAction func searchButtonTapped(_ sender: Any) {
        var input = searchTextField.text?.split(separator: "+").map{String($0)}
        
        if var input = input {
            if input.count == 2{
                //공백,여백 제거,치환
                var musicName = input[0].trimmingCharacters(in: .whitespacesAndNewlines)
                musicName = musicName.replacingOccurrences(of: " ", with: "%20")
                var artist = input[1].trimmingCharacters(in: .whitespacesAndNewlines)
                artist = artist.replacingOccurrences(of: " ", with: "%20")
                
                self.musicName = "\(musicName)%20\(artist)"
                self.artist = artist
            }
            else if input.count == 1{
                //공백,여백 제거,치환
                var musicName = input[0].trimmingCharacters(in: .whitespacesAndNewlines)
                musicName = musicName.replacingOccurrences(of: " ", with: "%20")
                self.musicName = musicName
                self.artist = musicName
            }else{
                self.showAlert(title: "검색어를 입력해 주세요")
            }
        }
        
        self.musics = []
        self.collectionView.reloadData()
        self.page = 1
        self.searchMusicWithAPI(searchKeyword: musicName, page: page)
        
        view.endEditing(true)
    }
    
    //MARK: Data 관련 함수
    
    //MusicData 호출
    func searchMusicWithAPI(searchKeyword: String, page: Int){
//        print("=======PAGE = \(self.page)========")
        if self.page == 1{
            self.attachActivityIndicator()
        }
        MusicSearchService.shared.searchMusic(searchKeyword: searchKeyword, page: page, completion: {(networkResult) in
            
            switch networkResult {
            case.success(let data):
                if let musicSearchData = data as? MusicSearchResult {
                    self.searchMusicDatas.append(contentsOf: musicSearchData.musicSearchRes)
                    
                    musicSearchData.musicSearchRes.forEach{
                        var name = $0.name
                        var artist = $0.artist
                        var coverImg = self.getImage(url: URL(string:$0.coverImg)!)
                        var musicPre = $0.musicPre
                        var music = Music_HaveImage(name: name, artist: artist, coverImg: coverImg, musicPre: musicPre)
                        self.musics.insert(music, at: 0)
                    }
                    if self.page == 1{
                        self.detachActivityIndicator()
                    }
                    
                    self.collectionView.reloadData()
                    self.refresh.endRefreshing()

                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in searchMusicWithAPI")
            case .serverErr:
                print("serverErr in searchMusicWithAPI")
            case .networkFail:
                print("networkFail in searchMusicWithAPI")
            }
        })
    }
    
    //musicPull 호출
    func searchMusicpullWithAPI(name: String, artist: String){
        MusicPullService.shared.pullMusicURL(name: name, artist: artist, completion: {(networkResult) in
            
            switch networkResult {
            case.success(let data):
                if let musicPull = data as? String {
                    self.musicPull = musicPull
                    self.musicForUpload.musicPull = self.musicPull
                    
                    let sb = UIStoryboard(name: "Upload", bundle: nil)
                    guard let viewController = sb.instantiateViewController(identifier: "UploadViewController") as? UploadViewController else {return}
//                    print("=====MusicSearchViewController.musicForUpload = \(self.musicForUpload)")
                    viewController.musicForUpload = self.musicForUpload
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in searchMusicpullWithAPI")
            case .serverErr:
                print("serverErr in searchMusicpullWithAPI")
            case .networkFail:
                print("networkFail in searchMusicpullWithAPI")
            }
        })
        
    }

    
    //MARK: 기타 함수
    
    //getImage 함수
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage()
        }
        return UIImage()
    }
    
    //showAlert
    func showAlert(title: String, message: String? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
           alertController.addAction(okAction)
           present(alertController, animated: true, completion: nil)
    }
}

extension MusicSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.musics.count
    }
    
    //cell 생성 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSearchCollectionViewCell", for: indexPath) as? MusicSearchCollectionViewCell else {return UICollectionViewCell()}
        
        cell.albumImageView.image = musics[indexPath.row].coverImg
        cell.artistLabel.text = musics[indexPath.row].artist
        cell.musicTitleLabel.text = musics[indexPath.row].name
        cell.setupCell()
   
        return cell
    }
    
  
    //cell selectdelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var musicDataForUpload = self.searchMusicDatas
        musicDataForUpload = musicDataForUpload.reversed()
        
        let music = musicDataForUpload[indexPath.row]
        
        print("===========cell selected================")
        
        //공백,여백 제거,치환
        var musicName = music.name.trimmingCharacters(in: .whitespacesAndNewlines)
        musicName = musicName.replacingOccurrences(of: " ", with: "%20")
        var artist = music.artist.trimmingCharacters(in: .whitespacesAndNewlines)
        artist = artist.replacingOccurrences(of: " ", with: "%20")
        
        //Get YoutubeLink
        self.searchMusicpullWithAPI(name: musicName, artist: artist)
        
        self.musicForUpload.name = music.name
        self.musicForUpload.coverImg = music.coverImg
        self.musicForUpload.musicPre = music.musicPre ?? ""
        self.musicForUpload.artist = music.artist
        

    }
}

extension MusicSearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width), height: 80)
    }
}

extension MusicSearchViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create a character set containing only English letters
        let englishLetters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ +")

        // Loop through each character in the replacement string
        for character in string {
            // Check if the character is NOT in the English letters character set
            if !englishLetters.contains(UnicodeScalar(String(character))!) {
                self.showAlert(title: "영어만 입력할 수 있습니다.")
                return false // Reject the input
            }
        }

        return true // Allow the input
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





















//
//import UIKit
//
//struct MusicSearchDataDummy{
//    let albumImage: UIImage
//    let albumTitle: String
//    let artist: String
//}
//
//
//
//
//class MusicSearchViewController: UIViewController {
//
//    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var searchButton: UIButton!
//    @IBOutlet var searchTextField: UITextField!
//    var searchDataListDummy:[MusicSearchDataDummy] = []
//    var searchMusicDatas: MusicSearchResult?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.configureCollectionView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//        self.searchDataListDummy = []
//        self.collectionView.reloadData()
//    }
//
//    @IBAction func searchButtonTapped(_ sender: Any) {
//        searchData()
//    }
//
//
//    func getImage(url: URL)-> UIImage{
//        if let data = try? Data(contentsOf: url) {
//            if let image = UIImage(data: data) {return image}
//        }else{
//            return UIImage()
//        }
//        return UIImage()
//    }
//
//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = false
//        activityIndicator.style = UIActivityIndicatorView.Style.medium
//        activityIndicator.startAnimating()
//        return activityIndicator
//    }()
//
//    private func attachActivityIndicator() {
//        self.view.addSubview(self.activityIndicator)
//    }
//
//    private func detachActivityIndicator() {
//        if self.activityIndicator.isAnimating {
//            self.activityIndicator.stopAnimating()
//        }
//        self.activityIndicator.removeFromSuperview()
//    }
//
//
//    //MusicData 호출
//    func searchMusicWithAPI(searchKeyword: String){
//        self.attachActivityIndicator()
//        MusicSearchService.shared.searchMusic(searchKeyword: searchKeyword, completion: {(networkResult) in
//            self.detachActivityIndicator()
//
//            switch networkResult {
//            case.success(let data):
//                if let musicSearchData = data as? MusicSearchResult {
//                    self.searchMusicDatas = musicSearchData
//                    self.collectionView.reloadData()
//                }
//            case .requestErr(let msg):
//                if let message = msg as? String {
//                    print(message)
//                }
//            case .pathErr:
//                print("pathErr in searchMusicWithAPI")
//            case .serverErr:
//                print("serverErr in searchMusicWithAPI")
//            case .networkFail:
//                print("networkFail in searchMusicWithAPI")
//            }
//        })
//    }
//    //musicPull 호출
//    func searchMusicpullWithAPI(){
//
//    }
//
//
//    //dummy data 받아오기
//    func searchData(){
//        let newJeansURL = URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/60x60bb.jpg")
//        let chaliputhURL = URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/60x60bb.jpg")
//        let dojacatURL = URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music116/v4/26/fe/b2/26feb2d2-c11b-cf95-4b93-d57321103566/196871142090.jpg/60x60bb.jpg")
//        let sebadohURL = URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music/d5/80/bd/mzi.nybhumzg.tif/60x60bb.jpg")
//
//        searchDataListDummy.append(MusicSearchDataDummy(albumImage: getImage(url: newJeansURL!), albumTitle: "Attention", artist: "NewJeans"))
//        searchDataListDummy.append(MusicSearchDataDummy(albumImage: getImage(url: chaliputhURL!), albumTitle: "Attention", artist: "Chalie Puth"))
//        searchDataListDummy.append(MusicSearchDataDummy(albumImage: getImage(url: dojacatURL!), albumTitle: "Attention", artist: "Doja Cat"))
//        searchDataListDummy.append(MusicSearchDataDummy(albumImage: getImage(url: sebadohURL!), albumTitle: "Attention", artist: "Sebadoh"))
//        self.searchTextField.text = ""
//        self.collectionView.reloadData()
//    }
//
//
//    //collectionView설정
//    private func configureCollectionView(){
//        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
//        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
//    }
//}
//
//extension MusicSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return searchDataListDummy.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSearchCollectionViewCell", for: indexPath) as? MusicSearchCollectionViewCell else {return UICollectionViewCell()}
//        cell.albumImageView.image = searchDataListDummy[indexPath.row].albumImage
//        cell.artistLabel.text = searchDataListDummy[indexPath.row].artist
//        cell.musicTitleLabel.text = searchDataListDummy[indexPath.row].albumTitle
//        cell.setupCell()
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let music = MusicForUpload(name: , coverImg: <#T##String#>, musicPre: <#T##String#>, artist: <#T##String#>, musicPull: <#T##String#>)
//        let sb = UIStoryboard(name: "Upload", bundle: nil)
//        guard let viewController = sb.instantiateViewController(identifier: "UploadViewController") as? UploadViewController else {return}
////        viewController.music = music
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
//}
//
//extension MusicSearchViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (UIScreen.main.bounds.width), height: 80)
//    }
//}
//
//
//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
