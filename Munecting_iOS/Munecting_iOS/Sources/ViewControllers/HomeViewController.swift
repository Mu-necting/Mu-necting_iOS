
import UIKit
import AVFoundation
import CoreImage
import MapKit


//dummy 구조체
struct Music: Codable{
    let name: String
    let coverImage: String
    let genre: String
    let musicPre: String
    let musicPull: String
    let replyCnt: Int
    let archiveId: Int
}


class HomeViewController: UIViewController {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var albumCoverImageView: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var musicTitle: UILabel!
    @IBOutlet var titleStackView: UIStackView!
    @IBOutlet var likeBarButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var replyCnt: UILabel!
    @IBOutlet var pickCnt: UILabel!
    
    
    var audioPlayer: AVPlayer?
    var curMusicNum: Int = 0
    var arroundMusics: [AroundMusic] = []
    var isLike: Bool = false
    var range:Int = 100
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    var tapGesture: UITapGestureRecognizer? = nil
    var pausedTime: CFTimeInterval = 0
    var savedTransform = UIImageView().layer.presentation()?.transform
    var startTransform = UIImageView().layer.presentation()?.transform


    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAlbumCoverImageView()
        self.AddAnimationAlbumCoverImage()
        self.setCLLocation()
        
        //주변 음악 가져오기
        locationManager.startUpdatingLocation()

        
        //albumCoverImageView TransForm 설정
        savedTransform = albumCoverImageView.layer.presentation()?.transform
        startTransform = albumCoverImageView.layer.presentation()?.transform
        
        if let presentationLayer = albumCoverImageView.layer.presentation() {
            self.startTransform = presentationLayer.transform
        }
        
        //test
        localJSONTest.shared.uploadMusicJSON()
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //내비게이션 바 없애기
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.audioPlayer?.pause()
    }
    

    //MARK: Setting 함수
    
    //Data로 UI Updata 및 노래 재생
    func updataUI(){
        self.musicTitle.textColor = .white
        let music = arroundMusics[self.curMusicNum]
        
        //음악 재생
        let musicURL = URL(string: music.musicPre)
        self.audioPlayer = AVPlayer(url: musicURL!)
        self.audioPlayer?.play()

        
        //노래 앨범 커버 이미지 설정
        let albumImage = getImage(url: URL(string: music.coverImg)!)
        backgroundImageView.image = albumImage.applyBlur(radius: 5.0)
        albumCoverImageView.image = albumImage
        
        //노래 타이틀, 아티스트, 장르 출력
        self.musicTitle.text = music.name
        self.artistNameLabel.text = music.artist
        self.genreLabel.text = "Genre : \(music.genre)"
        self.replyCnt.text = "\(music.replyCnt)"
        self.pickCnt.text = "\(music.pickCnt)"
    }
    
    //CLLocationManager 설정 함수
    func setCLLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //albumCoverImageView Animation 추가 함수
    func AddAnimationAlbumCoverImage(){
        //앨범 커버 360도 돌리기
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360도 회전 (2 * π 라디안)
        rotationAnimation.duration = 5.0 // 애니메이션 지속 시간 (초)
        rotationAnimation.repeatCount = .infinity // 무한 반복
        albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //albumCoverImageView 세팅 함수
    func setAlbumCoverImageView(){
        //gesture 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        self.albumCoverImageView.addGestureRecognizer(tapGesture)
        albumCoverImageView.isUserInteractionEnabled = true
        
        //앨범 커버 원형으로 만들기
        albumCoverImageView.layer.cornerRadius = 150
        albumCoverImageView.clipsToBounds = true
    }
    
    //imageViewTap 됐을 때 호출되는 objc 함수
    @objc func imageViewTapped(_ gesture: UITapGestureRecognizer){
        guard let currentTime = audioPlayer?.currentTime().seconds else {return}
        
        if(audioPlayer?.rate == 1.0){
            self.audioPlayer?.pause()
//            self.pauseRotationAnimation()
        }else{
//            self.resumeRotationAnimation()
            self.audioPlayer?.play()
        }
    }

    //Animation 멈추기
    func pauseRotationAnimation() {
          if let presentationLayer = albumCoverImageView.layer.presentation() {
              self.savedTransform = presentationLayer.transform
          }
        albumCoverImageView.layer.transform = self.startTransform ?? self.savedTransform!

          albumCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
      }
    
    //Animation 다시 재생
    func resumeRotationAnimation() {
        guard let transform = savedTransform else {
            return
        }

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360 degrees rotation (2 * π radians)
        rotationAnimation.duration = 5.0 // animation duration in seconds
        rotationAnimation.repeatCount = .infinity // repeat infinitely
        // Apply the saved transform to the view's layer
        albumCoverImageView.layer.transform = transform

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    

    //MARK: 좋아요, slider
    
    //좋아요 버튼
    @IBAction func likeButtonTapped(_ sender: Any) {
        if isLike == false{
            self.isLike = true
            self.likeButton.tintColor = .red
        }else{
            self.isLike = false
            self.likeButton.tintColor = .white
        }
    }
    
    //slider
    @IBAction func distanceSlider(_ sender: UISlider) {
        self.range = Int(sender.value)*100
        distanceLabel?.text = "\(range)m"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: 화면 이동 함수
    
    
    //뮤넥터 맵 이동함수
    @IBAction func munectingMapButtonTapped(_ sender: Any) {
        self.audioPlayer?.pause()
        let sb = UIStoryboard(name: "MunectingMap", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MunectingMapViewController") as? MunectingMapViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //Best Munector 화면 이동 함수
    @IBAction func bestMunectorButtonTapped(_ sender: Any) {
        self.audioPlayer?.pause()
        let sb = UIStoryboard(name: "BestMunector", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "BestMunectorViewController") as? BestMunectorViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    //다음 노래로 이동함수
    @IBAction func nextMusicButtonTapped(_ sender: Any) {
        
        if self.curMusicNum < self.arroundMusics.count-1{
            self.curMusicNum = self.curMusicNum + 1
        }else{
            self.curMusicNum = 0
        }
        
        //UI 업데이트 및 다음 음악 재생하기
        self.updataUI()
        
        //멈췄다가 다시 360도 돌기
        self.albumCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.AddAnimationAlbumCoverImage()
        }
    }
    
    //이전노래로 이동 함수
    @IBAction func previousMusicButtonTapped(_ sender: Any) {
        if(self.curMusicNum > 0){
            self.curMusicNum = self.curMusicNum - 1
        }else{
            self.curMusicNum = self.arroundMusics.count - 1
        }
        
        //UI 업데이트 및 이전 음악 재생하기
        self.updataUI()
        
        //멈췄다가 다시 360도 돌기
        self.albumCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.AddAnimationAlbumCoverImage()
        }
    }
    
    //유튜브 화면 이동 함수
    @IBAction func youtubeButtonTapped(_ sender: Any) {
        
        self.audioPlayer?.pause()
        
        let music = self.arroundMusics[self.curMusicNum]
        let musicPullURL = music.musicPull
        let sb = UIStoryboard(name: "Youtube", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "YoutubeModalViewController") as? YoutubeModalViewController else {return}
        viewController.musicPull = musicPullURL
        self.present(viewController, animated: true)
        
    }
    
    //pick 화면 이동 함수
    @IBAction func pickButtonTapped(_ sender: Any) {
        self.audioPlayer?.pause()
        let music = self.arroundMusics[self.curMusicNum]
   
        let sb = UIStoryboard(name: "Pick", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "PickViewController") as? PickViewController else {return}
        viewController.music = music
//            viewController.albumCoverImageView.image = self.getImage(url: URL(string: music.coverImage)!)
//            viewController.artistName.text = music.name
//            viewController.archievID = music.archiveId
            //수정 필요 -> MusicSearchArount 구조체 artist 추가 필요
//            viewController.trackNameLabel.text = music.name
        self.present(viewController, animated: true)
        
    }
    
    //UpLoad 화면 이동 함수
    @IBAction func uploadButtonTapped(_ sender: Any) {
        self.audioPlayer?.pause()
        let sb = UIStoryboard(name: "MusicSearch", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MusicSearchViewController") as? MusicSearchViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: Data 관련 함수
    
    //AroundMusic 가져오기 함수
    func getAroundMusicWithAPI(x: Double, y: Double, range: Int){
        MusicSearchAroundService.shared.searchAroundMusic(x: x, y: y, range: range, completion: {(networkResult) in
            switch networkResult{
            case .success(let data):
                if let arroundMusics = data as? [AroundMusic]{
                    if(arroundMusics.count == 0){
                        self.showAlert(title: "주변 \(range)m에 업로드 된 음악이 없습니다. \n추천 음악을 재생합니다.")
                        self.getDummyMusic()
                        self.updataUI()
                    }
                    else{
                        self.arroundMusics = arroundMusics
                        self.updataUI()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String { print(message) }
            case .pathErr:
                print("pathErr in getAroundMusicWithAPI")
            case .serverErr:
                print("serverErr in getAroundMusicWithAPI")
            case .networkFail:
                print("networkFail in getAroundMusicWithAPI")
            }
        })
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
        
        self.arroundMusics.append(dummyMusic1)
        self.arroundMusics.append(dummyMusic2)
        self.arroundMusics.append(dummyMusic3)
        self.arroundMusics.append(dummyMusic4)
        self.arroundMusics.append(dummyMusic5)
        self.arroundMusics.append(dummyMusic6)
    }
    
    
    //MARK: 기타 코드
    
    //url기반 이미지 반환 코드
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


extension HomeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.getAroundMusicWithAPI(x: self.latitude!, y: self.longitude!, range: self.range)
        locationManager.stopUpdatingLocation()
    }
}

