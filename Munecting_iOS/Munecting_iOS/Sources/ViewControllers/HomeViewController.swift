//
//  HomeViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/07/30.
//
import UIKit
import AVFoundation
import CoreImage



class HomeViewController: UIViewController {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var albumCoverImageView: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var musicTitle: UILabel!
    @IBOutlet var titleStackView: UIStackView!
    
    var audioPlayer: AVPlayer?
    var musics: [Music?] = []
    var curMusicNum: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleStackView.layer.cornerRadius = 10
//        titleStackView.backgroundColor = .systemGray5
//        titleStackView.alpha = 0.5
        
        //노래 갖고오기
        self.getMusic()
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        //내비게이션 바 없애기
        self.navigationController?.navigationBar.isHidden = true
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
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        let value = Int(sender.value)*100
        distanceLabel?.text = "\(value)m"
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
        let music1:Music = Music(name: "New Jeans", coverImage: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg", genre: "K-POP", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=o8RkbHv2_a0", replyCnt: 1, archiveId: 1)
        let music2:Music = Music(name: "Doja Cat", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music116/v4/26/fe/b2/26feb2d2-c11b-cf95-4b93-d57321103566/196871142090.jpg/100x100bb.jpg", genre: "Hip Hop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fe/2a/9a/fe2a9a4e-8afd-a670-7b25-e7d03d1f5522/mzaf_10350104113929572724.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=XweT8chMepU", replyCnt: 1, archiveId: 1)
        let music3:Music = Music(name: "Charlie Puth", coverImage: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/100x100bb.jpg", genre: "Pop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/b5/32/d4/b532d45b-0e4d-6bf3-d7b5-e02007877318/mzaf_10109990520611630125.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=6QYcd7RggNU", replyCnt: 1, archiveId: 1)
        let music4:Music = Music(name: "Sebadoh", coverImage: "https://is2-ssl.mzstatic.com/image/thumb/Music/d5/80/bd/mzi.nybhumzg.tif/100x100bb.jpg", genre: "Pop", musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview71/v4/bc/ae/b4/bcaeb4a0-0127-65f2-4eb2-75e82b08a95c/mzaf_4222798042305173586.plus.aac.p.m4a", musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08", replyCnt: 1, archiveId: 1)
        
        self.musics.append(music1)
        self.musics.append(music2)
        self.musics.append(music3)
        self.musics.append(music4)
        
    }
}

//이미지 Blur 처리 함수
extension UIImage {
    func applyBlur(radius: CGFloat) -> UIImage? {
        let context = CIContext(options: nil)
        guard let inputImage = CIImage(image: self) else { return nil }

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: inputImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
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
