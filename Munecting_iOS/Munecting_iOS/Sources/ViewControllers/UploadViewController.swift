//
//  UploadViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/04.
//

import UIKit
import MapKit


class UploadViewController: UIViewController {
    @IBOutlet var hiphopButton: UIButton!
    @IBOutlet var rockButton: UIButton!
    @IBOutlet var baladButton: UIButton!
    @IBOutlet var classicButton: UIButton!
    @IBOutlet var popButton: UIButton!
    @IBOutlet var bluesButton: UIButton!
    @IBOutlet var rnbButton: UIButton!
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var edmButton: UIButton!
    @IBOutlet var kpopButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var musicView: UIView!
    @IBOutlet var albumCover: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    var musicForUpload: MusicForUpload?
    var genre: String = ""
    var endTime:Int = 24
    var genreButtons: [UIButton] = []
    
    let cornerRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    var shadowOpacity: Float = 0.7
    var shadowRadius: CGFloat = 4.0
    let NavWhite = UIColor.navWhiteColor

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configureButtons()
        self.setCLLocation()
        self.locationManager.startUpdatingLocation()
        print("======musifForUpload = \(self.musicForUpload)")
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: 설정 함수들
    
    //CLLocationManager 설정 함수
    func setCLLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //UI설정
    func configUI(){
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.borderColor = UIColor.gray.cgColor
        timeLabel.layer.borderWidth = 0.8
        
        albumCover.layer.cornerRadius = 8
        albumCover.image = self.getImage(url: URL(string: self.musicForUpload?.coverImg ?? "https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c")!)
        
        self.nameLabel.text = self.musicForUpload?.name
        self.artistLabel.text = self.musicForUpload?.artist
        
    
        musicView.layer.cornerRadius = 8
        musicView.layer.borderColor = UIColor.systemGray5.cgColor
        musicView.layer.borderWidth = 1
        musicView.layer.shadowColor = self.NavWhite.cgColor
        musicView.layer.shadowOpacity = self.shadowOpacity
        musicView.layer.shadowOffset = self.shadowOffset
        musicView.layer.shadowRadius = self.cornerRadius
        musicView.layer.masksToBounds = false
    }
    
    //genreButton 설정
    func configureButtons(){
        hiphopButton.subtitleLabel?.text = "hiphop"
        rockButton.subtitleLabel?.text = "rock"
        baladButton.subtitleLabel?.text = "balad"
        classicButton.subtitleLabel?.text = "classic"
        popButton.subtitleLabel?.text = "pop"
        bluesButton.subtitleLabel?.text = "blues"
        rnbButton.subtitleLabel?.text = "rnb"
        countryButton.subtitleLabel?.text = "country"
        edmButton.subtitleLabel?.text = "edm"
        kpopButton.subtitleLabel?.text = "kpop"
        
        genreButtons = [self.hiphopButton,self.rockButton,self.baladButton,self.classicButton,self.popButton,
                            self.bluesButton, self.rnbButton, self.countryButton, self.edmButton, self.kpopButton]
    }


    //MARK: Slider, Buttons
    
    //timeSlider
    @IBAction func timeSlider(_ sender: UISlider) {
        let value = Int(sender.value)
        self.endTime = value
        self.musicForUpload?.endTime = value
        timeLabel.text = "\(String(value))시간"
    }

    //genreButton Tapped
    @IBAction func tappedGenreButton(_ sender: UIButton) {
        if sender.tintColor == .black{
            sender.tintColor = .white
            sender.backgroundColor = .munectingPurple
            sender.layer.cornerRadius = 10
            self.genre = sender.subtitleLabel!.text!
            
            self.genreButtons.forEach{
                if($0 != sender){
                    $0.tintColor = .black
                    $0.backgroundColor = .white 
                }
            }
        }else{
            sender.tintColor = .black
            sender.backgroundColor =  .white
            self.genre = ""
        }
        
    }
    
    //UploadButton Tapped
    @IBAction func tappedUploadButton(_ sender: Any) {
        print("======tappedUploadButton======")
        if genre == "" {
            showAlert(title: "장르를 설정해 주세요")
            return
        }
        self.musicForUpload?.genre = self.genre
        self.musicForUpload?.endTime = self.endTime
        guard let musicForUpload = self.musicForUpload else {return}
        self.uploadMusicWithAPI(musicForUpload: musicForUpload)

    }
    
    //MARK: Data 관련 함수
    
    //MusicUpload
    func uploadMusicWithAPI(musicForUpload: MusicForUpload){
        print("======uploadMusicWithAPI In======")
        let name = musicForUpload.name
        let coverImg = musicForUpload.coverImg
        let musicPre = musicForUpload.musicPre
        guard let musicPull = musicForUpload.musicPull else {return}
        let artist = musicForUpload.artist
        guard let genre = musicForUpload.genre else {return}
        guard let endTime = musicForUpload.endTime else {return}
        print("======endTime======")
        guard let pointX = musicForUpload.pointX else {return}
        guard let pointY = musicForUpload.pointY else {return}
        print("======좌표======")
        guard let userID = UserManager.shared.getUser()?.userID else {return}
//        let userID = 1

        print("======프로퍼티 unwraping 성공======")
        MusicUploadService.shared.uploadMusic(name: name,
                                              coverImg: coverImg,
                                              musicPre: musicPre,
                                              musicPull: musicPull,
                                              artist: artist,
                                              genre: genre,
                                              endTime: endTime,
                                              pointX: pointX,
                                              pointY: pointY,
                                              memberID: userID,
                                              completion: {(networkResult) in
            switch networkResult {
            case.success(_):
                let sb = UIStoryboard(name: "Home", bundle: nil)
                guard let viewController = sb.instantiateViewController(identifier: "PageViewController") as? PageViewController else {return}
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController, animated: true)
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
    
    
    
    
    //MARK: 기타 함수
    
    //getImage
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

extension UploadViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.musicForUpload?.pointX = locValue.latitude
        self.musicForUpload?.pointY = locValue.longitude
        locationManager.stopUpdatingLocation()
    }
}
