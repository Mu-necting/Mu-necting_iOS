//
//  SettingViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/21.
//

import UIKit

class SettingViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    let data = ["로그아웃", "회원탈퇴","비밀번호 변경"]
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var menuView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.menuView = UITableView()
        
        self.menuView.dataSource = self
        self.menuView.delegate = self
        
        self.menuView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        

        self.view.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            // 위쪽 제약조건: tableView의 상단과 네비게이션 바의 하단 사이 간격을 2으로 설정
            menuView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                          constant : 2),
            // 좌측 제약조건: tableView의 좌측은 뷰의 좌측과 일치
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // 우측 제약조건: tableView의 우측은 뷰의 우측과 일치
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18),
            // 아래쪽 제약조건: tableView의 아래쪽은 뷰의 아래쪽과 일치
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
      }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50 // 각 셀의 높이를 50으로 설정
        }

}
