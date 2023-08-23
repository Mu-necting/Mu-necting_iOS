//
//  BestMunectorUITestViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//
import UIKit

struct MunectingRankCollectionViewStruct{
    var profile: String
    var nick: String
    var allReplyCnt: Int
    var rank: Int
}

class BestMunectorViewController: UIViewController {
    
    @IBOutlet var firstPersonImageView: UIImageView!
    @IBOutlet var thirdPersonImageView: UIImageView!
    @IBOutlet var secondPersonImageView: UIImageView!
    @IBOutlet var personBackgroundView: UIView!
    @IBOutlet var secondBackgroundView: UIView!
    @IBOutlet var thirdBackgroundView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var collectionViewData:[MunectingRankCollectionViewStruct] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.munectingPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMunectingRankDataWithAPI(rank: 10)
        self.configureRankerView()
        self.configureCollectionView()
        
        self.view.backgroundColor = .white
    }
    
    //MARK: 기본 설절 함수
    
    //Ranker Image 설정
    private func configureRankerView(){
        personBackgroundView.layer.cornerRadius = 110 / 2
        personBackgroundView.layer.masksToBounds = true
        personBackgroundView.backgroundColor = UIColor.munectingPurple
        personBackgroundView.layer.masksToBounds = true
        
        secondBackgroundView.layer.cornerRadius = 90/2
        secondBackgroundView.layer.masksToBounds = true
        secondBackgroundView.backgroundColor = UIColor.munectingPurple
        secondBackgroundView.layer.masksToBounds = true
        
        thirdBackgroundView.layer.cornerRadius = 90/2
        thirdBackgroundView.layer.masksToBounds = true
        thirdBackgroundView.backgroundColor = UIColor.munectingPurple
        thirdBackgroundView.layer.masksToBounds = true
        
        
        firstPersonImageView.layer.cornerRadius = 102/2
        secondPersonImageView.layer.cornerRadius = 85/2
        thirdPersonImageView.layer.cornerRadius = 85/2
    }
    
    //CollectionView 설정
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    //MARK: 데이터 가져오기 함수
    
    //RankData 가져오기
    func getMunectingRankDataWithAPI(rank:Int){
        MunectingRankService.shared.searchMunectingRank(rank: rank, completion: {(networkResult) in
            switch networkResult {
            case.success(let data):
                if let munectingRankData = data as? [MunectingRankData] {
                    munectingRankData.forEach{
                        var profile = $0.profile
                        var nick = $0.nick
                        var allReplyCnt = $0.allReplyCnt
                        var rank = $0.rank
                        //error 확인하기
                        var userRankData = MunectingRankCollectionViewStruct(profile: profile!, nick: nick, allReplyCnt: allReplyCnt, rank: rank)
                        self.collectionViewData.append(userRankData)
                    }
                    self.collectionViewData = self.collectionViewData.sorted { $0.rank < $1.rank }
                    self.collectionView.reloadData()
                }
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


extension BestMunectorViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestMunectorTestCollectionViewCell", for: indexPath) as? BestMunectorTestCollectionViewCell else {return UICollectionViewCell()}
        cell.commmonInit()
        cell.rankingLabel.text = "\(indexPath.row+4)"
        
//        cell.userImage = self.collectionViewData[indexPath.row].profile
//        cell.userIDLabel.text = self.collectionViewData[indexPath.row].nick
//        cell.replyCntLabel.text = "\(self.collectionViewData[indexPath.row].allReplyCnt)"
 
        return cell
    }
}

extension BestMunectorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width), height: 80)
    }
}
