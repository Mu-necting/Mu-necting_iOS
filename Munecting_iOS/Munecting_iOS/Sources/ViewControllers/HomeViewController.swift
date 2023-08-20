//
//  HomeViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/07/30.
//
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

    
    var audioPlayer: AVPlayer?
    var musics: [Music?] = []
    var curMusicNum: Int = 0
    var arroundMusics: MusicSearchAround?
    var isLike: Bool = false
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleStackView.layer.cornerRadius = 10
        
        //CLLocationManager 설정
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        
        //더미 노래 갖고오기
        self.getMusic()
        self.loadJSON()

        //근처 노래 갖고오기
//        self.getAroundMusicWithAPI(x: latitude!, y: longitude!, range: 100)
        
        if let music = musics[0]{
            //첫 번째 노래 재생
            let musicURL = URL(string: music.musicPre)
            self.audioPlayer = AVPlayer(url: musicURL!)
            self.audioPlayer?.play()

            
            //첫 번재 노래 커버 이미지 설정
            let albumImage = getImage(url: URL(string: music.coverImage)!)
            backgroundImageView.image = albumImage.applyBlur(radius: 5.0)
            albumCoverImageView.image = albumImage
            
            //노래 타이틀, 아티스트, 장르 출력
            self.musicTitle.text = "Attention"
            self.artistNameLabel.text = music.name
            self.genreLabel.text = "Genre : \(music.genre)"

        }
        
        //앨범 커버 원형으로 만들기
        albumCoverImageView.layer.cornerRadius = albumCoverImageView.frame.size.width/2
        albumCoverImageView.clipsToBounds = true
        
        //앨범 커버 360도 돌리기
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360도 회전 (2 * π 라디안)
        rotationAnimation.duration = 5.0 // 애니메이션 지속 시간 (초)
        rotationAnimation.repeatCount = .infinity // 무한 반복
        albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    //임시 함수_JSON 디코딩
    func loadJSON(){
        if let path = Bundle.main.path(forResource: "musicSearch", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(GenericResponse<MusicSearchResult>.self, from: jsonData)
                
                print("Is Success:", response.isSuccess)
                print("Code:", response.code)
                print("Message:", response.message)
                print("Total Page:", response.result.totalPage)
                print("Music Items:", response.result.musicSearchRes[0])
            } catch {
                print("Error:", error)
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //내비게이션 바 없애기
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if isLike == false{
            self.isLike = true
            self.likeButton.tintColor = .red
        }else{
            self.isLike = false
            self.likeButton.tintColor = .white
        }
    }
    
    //뮤넥터 맵 이동함수
    @IBAction func munectingMapButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "MunectingMap", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MunectingMapViewController") as? MunectingMapViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //Best Munector 화면 이동 함수
    @IBAction func bestMunectorButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "BestMunector", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "BestMunectorViewController") as? BestMunectorViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    //slider
    @IBAction func distanceSlider(_ sender: UISlider) {
        let range = Int(sender.value)*100
        distanceLabel?.text = "\(range)m"
        
        
    }
    
    //다음 노래로 이동함수
    @IBAction func nextMusicButtonTapped(_ sender: Any) {
        
        if self.curMusicNum < self.musics.count-1{
            self.curMusicNum = self.curMusicNum + 1
        }else{
            self.curMusicNum = 0
        }
        
        if let music = self.musics[self.curMusicNum] {
            // 다음 노래 재생
            let musicURL = URL(string: music.musicPre)
            self.audioPlayer = AVPlayer(url: musicURL!)
            self.audioPlayer?.play()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
//                self.audioPlayer = AVPlayer(url: musicURL!)
//                self.audioPlayer?.play()
//            }
            
            //앨범 커버 이미지 설정
            let albumImage = getImage(url: URL(string: music.coverImage)!)
            backgroundImageView.image = albumImage.applyBlur(radius: 5.0)
            albumCoverImageView.image = albumImage
            
            //아티스트 이름, 장르 이름 설정
            self.artistNameLabel.text = music.name
            self.genreLabel.text = "Genre : \(music.genre)"        }
        
        //멈췄다가 다시 360도 돌기
        self.albumCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360도 회전 (2 * π 라디안)
        rotationAnimation.duration = 5.0 // 애니메이션 지속 시간 (초)
        rotationAnimation.repeatCount = .infinity // 무한 반복
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
        

    }
    
    //이전노래로 이동 함수
    @IBAction func previousMusicButtonTapped(_ sender: Any) {
        if(self.curMusicNum > 0){
            self.curMusicNum = self.curMusicNum - 1
        }else{
            self.curMusicNum = self.musics.count - 1
        }
        
        if let music = self.musics[self.curMusicNum] {
            // 이전 노래 재생
            let musicURL = URL(string: music.musicPre)
            self.audioPlayer = AVPlayer(url: musicURL!)
            self.audioPlayer?.play()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
//                self.audioPlayer = AVPlayer(url: musicURL!)
//                self.audioPlayer?.play()
//            }
            
            //앨범 커버 이미지 설정
            let albumImage = getImage(url: URL(string: music.coverImage)!)
            backgroundImageView.image = albumImage.applyBlur(radius: 5.0)
            albumCoverImageView.image = albumImage
            
            //아티스트 이름, 장르 이름 설정
            self.artistNameLabel.text = music.name
            self.genreLabel.text = "Genre : \(music.genre)"        }
        
        //멈췄다가 다시 360도 돌기
        self.albumCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360도 회전 (2 * π 라디안)
        rotationAnimation.duration = 5.0 // 애니메이션 지속 시간 (초)
        rotationAnimation.repeatCount = .infinity // 무한 반복
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    //유튜브 화면 이동 함수
    @IBAction func youtubeButtonTapped(_ sender: Any) {
        
        self.audioPlayer?.pause()
        
        if let music = self.musics[self.curMusicNum] {
            let musicPullURL = music.musicPull
            let sb = UIStoryboard(name: "Youtube", bundle: nil)
            guard let viewController = sb.instantiateViewController(identifier: "YoutubeModalViewController") as? YoutubeModalViewController else {return}
            viewController.musicPull = musicPullURL
            self.present(viewController, animated: true)
        }
    }
    
    //UpLoad 화면 이동 함수
    @IBAction func uploadButtonTapped(_ sender: Any) {
        self.audioPlayer?.pause()
        let sb = UIStoryboard(name: "MusicSearch", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MusicSearchViewController") as? MusicSearchViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getAroundMusicWithAPI(x: Double, y: Double, range: Int){
        MusicSearchAroundService.shared.searchAroundMusic(x: x, y: y, range: range, completion: {(networkResult) in
            
            switch networkResult{
            case .success(let data):
                if let arroundMusics = data as? MusicSearchAround{
                    self.arroundMusics = arroundMusics
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
    
    
    //url기반 이미지 반환 코드
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage()
        }
        return UIImage()
    }
    
    //music 갖고오기
    func getMusic(){
        let music1:Music = Music(name: "NewJeans", coverImage: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg", genre: "K-POP", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=o8RkbHv2_a0", replyCnt: 1, archiveId: 1)
        let music2:Music = Music(name: "Doja Cat", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music116/v4/26/fe/b2/26feb2d2-c11b-cf95-4b93-d57321103566/196871142090.jpg/100x100bb.jpg", genre: "Hip Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fe/2a/9a/fe2a9a4e-8afd-a670-7b25-e7d03d1f5522/mzaf_10350104113929572724.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=XweT8chMepU", replyCnt: 1, archiveId: 1)
        let music3:Music = Music(name: "Charlie Puth", coverImage: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/100x100bb.jpg", genre: "Pop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/b5/32/d4/b532d45b-0e4d-6bf3-d7b5-e02007877318/mzaf_10109990520611630125.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=6QYcd7RggNU", replyCnt: 1, archiveId: 1)
        let music4:Music = Music(name: "Sebadoh", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music/d5/80/bd/mzi.nybhumzg.tif/100x100bb.jpg", genre: "Pop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview71/v4/bc/ae/b4/bcaeb4a0-0127-65f2-4eb2-75e82b08a95c/mzaf_4222798042305173586.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        let music5:Music = Music(name: "Beenzino", coverImage: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/76/bc/37/76bc37d2-283d-f252-716e-183c268b8a87/197189280801.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fc/05/e9/fc05e999-0e4f-2a28-e21d-3fd55a671208/mzaf_13793805966112651018.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        
        let music6:Music = Music(name: "250", coverImage: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/b5/9c/27/b59c2792-bb97-2a40-f482-c6d5b3ae1cea/196626603180.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/79/97/b3/7997b3fd-b8b8-0540-787a-0ef0988e807c/mzaf_6188522879362145428.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        let music7:Music = Music(name: "C JAMM", coverImage: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/02/6a/99/026a998e-835f-81a9-d5e5-f0fbf091caf7/cover-C_JAMM_NEW.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/2c/7d/fc/2c7dfcb8-4c6b-f691-9c76-8fe499c3d6b7/mzaf_3230752141782334299.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        let music8:Music = Music(name: "Travis Scott", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/09/7d/b0/097db06f-8403-3cf7-7510-139e570ca66b/196871341882.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/f6/c0/d8/f6c0d812-9f77-ec3b-4e93-97d9264f1949/mzaf_8903675728836112418.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        let music9:Music = Music(name: "Kanye West", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/3c/56/e7/3c56e717-06a0-b67d-e694-9b6e6e43a5a8/13UAAIM08444.rgb.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/0c/10/8f/0c108f4d-c3dc-4374-ceb3-080aaaadc341/mzaf_17782097658048434538.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        let music10:Music = Music(name: "NewJeans", coverImage: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/63/e5/e2/63e5e2e4-829b-924d-a1dc-8058a1d69bd4/196922462702_Cover.jpg/100x100bb.jpg", genre: "Hip-Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/98/66/db/9866dbb4-6e6f-eedd-ea1c-4832542b8f3e/mzaf_1940197871229851903.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        
        
        self.musics.append(music1)
        self.musics.append(music2)
        self.musics.append(music3)
        self.musics.append(music4)
        self.musics.append(music5)
        self.musics.append(music6)
        self.musics.append(music7)
        self.musics.append(music8)
        self.musics.append(music9)
        self.musics.append(music10)
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
    }
}




































/*
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var distanceTextField: UITextField!
    var distance = ["100m", "200m", "300m", "400m", "500m"]
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePickerView()
    }
    
    func configurePickerView(){
        picker.delegate = self
        picker.dataSource = self
        distanceTextField.inputView = picker
        configToolbar()
    }
    
    
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.distance.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.distanceTextField.text = self.distance[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.distance[row]
    }
    func configToolbar(){
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.systemGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        cancelButton.tintColor = .systemBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton,flexibleSpace,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.distanceTextField.inputAccessoryView = toolBar
    }
    
    // "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        let row = self.picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.distanceTextField.text = self.distance[row]
        self.distanceTextField.resignFirstResponder()
    }

    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        self.distanceTextField.text = nil
        self.distanceTextField.resignFirstResponder()
    }
}
*/
