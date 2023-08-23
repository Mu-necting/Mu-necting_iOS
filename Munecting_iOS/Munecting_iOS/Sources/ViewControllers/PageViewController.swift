//
//  PageViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//

import UIKit

struct pageIndex{
    static let shared = pageIndex()
    var Index = 1
}

class PageViewController: UIViewController {
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return vc
    }()
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .black

        return view
    }()
    var dataViewControllers: [UIViewController] = []
    var pageIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegate()
        self.configure()
        
 
        
        let archieveSb = UIStoryboard(name: "ArchivePage", bundle: nil )
        guard let archiveViewController = archieveSb.instantiateViewController(identifier: "ArchiveViewController") as? ArchiveViewController else {return}
        
        guard let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeNavigationViewController") as? HomeNavigationViewController else {return}
        let MusicSearchSb = UIStoryboard(name: "MusicSearch", bundle: nil)
        
        guard let uploadViewController = MusicSearchSb.instantiateViewController(identifier: "MusicSearchNavigationController") as? MusicSearchNavigationController else {return}
        
        dataViewControllers = [uploadViewController, homeViewController, archiveViewController]
        pageViewController.setViewControllers([dataViewControllers[self.pageIndex]], direction: .forward, animated: true, completion: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("=====viewWillAppear=========")
        self.pageIndex = 1
        pageViewController.setViewControllers([dataViewControllers[self.pageIndex]], direction: .forward, animated: true, completion: nil)

    }
    
    private func setupDelegate() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func configure(){
        view.addSubview(navigationView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false


        
        let constraint = [
            navigationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 0),
            pageViewController.view.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(constraint)
        pageViewController.didMove(toParent: self)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else {return nil}
        let previousIndex = index - 1
        if previousIndex < 0{
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
}
