//
//  ProfileTutorialViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/04.
//

import Foundation
import UIKit
import Photos

class ProfileTutorialViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var profileView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileView))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserManager.shared.setUserName(name: userNameTextField.text ?? "")
    }
    
    @objc func onTapProfileView(){
        
        switch PHPhotoLibrary.authorizationStatus() {
            // 사용자가 접근을 허용했을 때
        case .authorized: break
            // 사용자가 아직 권한에 대한 설정을 하지 않았을 때
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                print(status)
            }
        case .denied: break
            // 접근이 거부된 경우
        case .limited: break
            // 갤러리의 접근이 선택한 사진만 허용된 경우
        @unknown default:
            fatalError()
        }
        
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileView.image = image
            UserManager.shared.setUserPrevSaveImage(image: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

