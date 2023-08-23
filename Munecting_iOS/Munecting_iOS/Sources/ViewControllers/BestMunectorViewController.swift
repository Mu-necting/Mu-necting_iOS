//
//  BestMunectorUITestViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//
import UIKit

struct MunectingRankCollectionViewStruct{
    var profile: UIImage
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
    @IBOutlet var firstReplyCntLabel: UILabel!
    @IBOutlet var secondReplyCntLabel: UILabel!
    @IBOutlet var thirdReplyCntLabel: UILabel!
    @IBOutlet var firstNickLabel: UILabel!
    @IBOutlet var secondNickLabel: UILabel!
    @IBOutlet var thirdNickLabel: UILabel!
    
    var collectionViewData:[MunectingRankCollectionViewStruct] = []
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMunectingRankDataWithAPI(rank: 10)
        self.configureCollectionView()
        self.configureRankerView()
        
        self.view.backgroundColor = .white
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.munectingPurple
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
        
        
        firstPersonImageView.layer.cornerRadius = 105/2
        secondPersonImageView.layer.cornerRadius = 85/2
        thirdPersonImageView.layer.cornerRadius = 85/2
        

        
    }
    
    func rankerUIUpdate(){
    
        

        if self.collectionViewData.count > 3{
            self.firstPersonImageView.image = collectionViewData[2].profile
            self.firstNickLabel.text = collectionViewData[2].nick
            self.firstReplyCntLabel.text = "\(collectionViewData[2].allReplyCnt)"
        }
        
        if self.collectionViewData.count > 2{
            self.secondPersonImageView.image = collectionViewData[1].profile
            self.secondNickLabel.text = collectionViewData[1].nick
            self.secondReplyCntLabel.text = "\(collectionViewData[1].allReplyCnt)"
        }
        
        if self.collectionViewData.count > 1{
            self.thirdPersonImageView.image = collectionViewData[0].profile
            self.thirdNickLabel.text = collectionViewData[0].nick
            self.thirdReplyCntLabel.text = "\(collectionViewData[0].allReplyCnt)"
        }
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
                        var nick = $0.nick
                        var allReplyCnt = $0.allReplyCnt
                        var rank = $0.rank
                        
                        if let profile = $0.profile{
                            print("=========URL: \(profile)=========")
                            var profile = self.getImage(url: URL(string: profile)!)
                            //error 확인하기
                            var userRankData = MunectingRankCollectionViewStruct(profile: profile, nick: nick, allReplyCnt: allReplyCnt, rank: rank)
                            self.collectionViewData.append(userRankData)
                        }
                        else{
                            var profile = UIImage.init(systemName: "person.circle.fill")
                            var userRankData = MunectingRankCollectionViewStruct(profile: profile!, nick: nick, allReplyCnt: allReplyCnt, rank: rank)
                            self.collectionViewData.append(userRankData)
                        }
                    }
                    self.collectionViewData = self.collectionViewData.sorted { $0.rank < $1.rank }
                    self.rankerUIUpdate()
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
    
    //MARK: 기타 함수
    
    //url기반 이미지 반환 코드
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage()
        }
        return UIImage()
    }
    
}


extension BestMunectorViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    //collectionView Item수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.collectionViewData.count > 3){
            return self.collectionViewData.count-3
        }else{
            return 0
        }
    }
    
    //collectionView cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestMunectorTestCollectionViewCell", for: indexPath) as? BestMunectorTestCollectionViewCell else {return UICollectionViewCell()}
        cell.commmonInit()
        cell.rankingLabel.text = "\(indexPath.row+4)"
        cell.userImage.image = self.collectionViewData[indexPath.row+3].profile
        cell.userIDLabel.text = self.collectionViewData[indexPath.row+3].nick
        cell.replyCntLabel.text = "\(self.collectionViewData[indexPath.row+3].allReplyCnt)"
 
        return cell
    }
}

//collectionView ItemSize 설정
extension BestMunectorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width), height: 80)
    }
}
