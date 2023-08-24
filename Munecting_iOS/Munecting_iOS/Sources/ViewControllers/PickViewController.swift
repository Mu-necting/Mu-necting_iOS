//
//  PickViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/21.
//

import UIKit

class PickViewController: UIViewController {

    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var albumCoverImageView: UIImageView!
    @IBOutlet var writingTextView: UITextView!
    
    var music: AroundMusic = AroundMusic(name: "", coverImg: "", genre: "", musicPre: "", musicPull: "", replyCnt: 0, archiveId: 0, artist: "", pickCnt: 0)
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetPresentationController?.prefersGrabberVisible = true
        self.albumCoverImageView.layer.cornerRadius = 10
        self.albumCoverImageView.image = getImage(url: URL(string: music.coverImg)!)
        self.artistName.text = music.artist
        self.trackNameLabel.text = music.name
    }
    
    
    @IBAction func tappedWritingButton(_ sender: Any) {
        print("======tappedWritingButton=====")
        guard let writing = writingTextView.text else {return}
        print("======writing ok=====")
        guard let memberID = UserManager.shared.getUser()?.userID else {return}
        
        self.pickWithAPI(writing: writing, memberId: memberID, archiveId: music.archiveId)
    }
    
    func pickWithAPI(writing: String, memberId: Int, archiveId: Int){
        print("========pickWithAPI==========")
        PickService.shared.PickMusic(writing: writing, memberId: memberId, archievId: archiveId, completion: {(networkResult) in
            
            switch networkResult {
            case.success(_):
                self.dismiss(animated: true, completion: nil)
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
