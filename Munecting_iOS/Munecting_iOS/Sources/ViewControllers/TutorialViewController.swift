//
//  TutorialViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/04.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController{
    
    @IBOutlet weak var pageView: UIView!
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var currentPage = 0
    
    let viewsList : [UIViewController] = {
         
         let storyBoard = UIStoryboard(name: "Tutorial", bundle: nil)
        
         let vc1 = storyBoard.instantiateViewController(withIdentifier: "ProfileTutorialViewController")
         let vc2 = storyBoard.instantiateViewController(withIdentifier: "FinalTutorialViewController")
         
         return [vc1, vc2]
         
     }()

    @IBOutlet weak var tutorialContentFirstLine: UILabel!
    
    @IBOutlet weak var tutorialContentSecondLine: UILabel!
 
    override func viewDidLoad() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let firstvc = viewsList.first{
            //setViewControllers(첫번째화면, direction: .forward(앞으로), .reverse(뒤로), animated: 애니메이션(Bool), completion: nil)
            pageViewController.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
        
        
        //MARK: Main View안에 viewController 붙여넣기
        //pageViewController크기와 Main의 view크기와 맞춰서 addSubView로 main에 있는 view에 넣어준다.
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: pageView.frame.width, height: pageView.frame.height)
        self.pageView.addSubview(pageViewController.view)
    }
    
    
    
    @IBAction func nextPage(_ sender: Any) {
        if(currentPage == (viewsList.count - 1)){
            // 업로드 페이지로 이동
            let user: User = UserManager.shared.getUser()!
            
            LoadingIndicator.showLoading()
            
            UserService.changeProfile(name: user.userName!, profileImage: UserManager.shared.getPreSaveImage()){
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    let user : User = data as! User
                    UserManager.shared.setUser(user)
                    
                    let musicSearchVC =  UIStoryboard(name: "MusicSearch", bundle: nil)
                                    .instantiateViewController(withIdentifier: "MusicSearchNavigationController")
                                
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(musicSearchVC, animated: true)
                    
                case .requestErr(let msg):
                    if let message = msg as? String {
                        print(message)
                    }
                case .pathErr:
                    print("pathErr in loginWithSocialAPI")
                case .serverErr:
                    print("serverErr in loginWithSocialAPI")
                case .networkFail:
                    print("networkFail in loginWithSocialAPI")
                }
                
                LoadingIndicator.hideLoading()
            }
            
        }else{
            let nextPage = currentPage + 1
            //화면 이동 (지금 페이지에서 -1 페이지로 setView 합니다.)
            pageViewController.setViewControllers([viewsList[nextPage]], direction: .forward, animated: true)
                    
            //현재 페이지 잡아주기
            currentPage = nextPage
        }
    }
}

extension TutorialViewController:  UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController],transitionCompleted completed: Bool){
        //지금 페이지
        currentPage = pageViewController.viewControllers!.first!.view.tag
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //다음페이지 이동
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }
        return viewsList[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //이전페이지 이동
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewsList[previousIndex]
    }
}
