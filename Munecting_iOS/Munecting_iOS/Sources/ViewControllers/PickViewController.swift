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
    var archievID: Int?
    var memberID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetPresentationController?.prefersGrabberVisible = true
        self.albumCoverImageView.layer.cornerRadius = 10
        self.memberID = UserManager.shared.getUser()?.userID
    }
    
    @IBAction func tappedWritingButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickWithAPI(writing: String, memberId: Int, archiveId: Int){
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
    


}
