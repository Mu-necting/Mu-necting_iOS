//
//  HomeViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/07/30.
//
import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    
    var picker = UIPickerView()
    var audioPlayer: AVPlayer?
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var albumCoverImageView: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let musicURL = URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fe/2a/9a/fe2a9a4e-8afd-a670-7b25-e7d03d1f5522/mzaf_10350104113929572724.plus.aac.p.m4a")
        self.audioPlayer =  AVPlayer(url: musicURL!)
        self.audioPlayer?.play()
//        self.configurePickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        self.audioPlayer?.pause()
        let sb = UIStoryboard(name: "MusicSearch", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MusicSearchViewController") as? MusicSearchViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func distanceSlider(_ sender: UISlider) {
        let value = Int(sender.value)*100
        distanceLabel?.text = "\(value)m"
    }
    
//    func configurePickerView(){
//        picker.delegate = self
//        picker.dataSource = self
//        distanceTextField.inputView = picker
//        configToolbar()
//    }
//
    @IBAction func youtubeButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://www.youtube.com/watch?v=o8RkbHv2_a0") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
    @IBAction func nextMusicButtonTapped(_ sender: Any) {
        let musicURL = URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a")
        self.audioPlayer =  AVPlayer(url: musicURL!)
        self.audioPlayer?.play()
        self.albumCoverImageView.image = getImage(url: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg")!)
        self.artistNameLabel.text = "New Jeans"
        self.genreLabel.text = "#K-POP"
    }
    @IBAction func munectingMapButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "MunectingMap", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "MunectingMapViewController") as? MunectingMapViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func bestMunectorButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "BestMunector", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "BestMunectorViewController") as? BestMunectorViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage()
        }
        return UIImage()
    }
}

/*
extension HomeViewController: {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
@ -48,19 +106,19 @@ extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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

     "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        let row = self.picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
@ -74,3 +132,4 @@ extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
        self.distanceTextField.resignFirstResponder()
    }
}
*/



































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
