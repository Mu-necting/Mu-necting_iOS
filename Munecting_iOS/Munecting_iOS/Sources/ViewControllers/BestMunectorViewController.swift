//
//  BestMunectorUITestViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//
import UIKit
import Alamofire

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
//        self.getMunectingRankDataWithAPI(rank: 10)
        self.getDummy()
        self.rankerUIUpdate()
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

//    func loadProfileImage() {
//        if let profileImageURL = UserManager.shared.getUser()?.profileImage {
//            // Alamofire를 사용하여 프로필 이미지 다운로드
//            AF.request(profileImageURL).responseImage { response in
//                switch response.result {
//                case .success(let image):
//                    self.profileImg.image = image
//                case .failure(let error):
//                    print("Error downloading profile image: \(error)")
//                }
//            }
//        }
//    }
    
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
                        var profile = $0.profile
                        var profileImage = self.getImage(url: URL(string: "https://munecting.s3.us-east-2.amazonaws.com/" + profile!)!)
                        
                        var userRankData = MunectingRankCollectionViewStruct(profile: profileImage, nick: nick, allReplyCnt: allReplyCnt, rank: rank)
                        self.collectionViewData.append(userRankData)
                        
                        
//                        let profileImage = "https://munecting.s3.us-east-2.amazonaws.com/" + profile!
//                        AF.request(profileImage).responseImage{ response in
//                            switch response.result{
//                            case .success(let image):
//                                var userRankData = MunectingRankCollectionViewStruct(profile: image, nick: nick, allReplyCnt: allReplyCnt, rank: rank)
//                                self.collectionViewData.append(userRankData)
//                            case .failure(let error):
//                                print("Error downloading profile image: \(error)")
//                            }
//                        }
                    }
                    self.collectionViewData = self.collectionViewData.sorted { $0.rank < $1.rank }
                    self.rankerUIUpdate()
                    print("=============collectionViewData===========")
                    print("\(self.collectionViewData)")
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
    
    //getDummy
    func getDummy(){
        for _ in 1...30 {
             // Generate random profile image (replace with your logic)
             let randomProfileImage = UIImage(systemName: "person.fill")!
             
             // Generate random nick name (replace with your logic)
             let randomNick = "User" + String(Int.random(in: 1...100))
             
             // Generate random allReplyCnt and rank (replace with your logic)
             let randomAllReplyCnt = Int.random(in: 0...100)
             let randomRank = Int.random(in: 1...30)
             
             // Create a MunectingRankCollectionViewStruct instance
             let data = MunectingRankCollectionViewStruct(profile: randomProfileImage,
                                                         nick: randomNick,
                                                         allReplyCnt: randomAllReplyCnt,
                                                         rank: randomRank)
            
            self.collectionViewData = self.collectionViewData.sorted { $0.allReplyCnt > $1.allReplyCnt }
            self.collectionViewData.append(data)
         }
    }
    
    //MARK: 기타 함수
    
    //url기반 이미지 반환 코드
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage(systemName: "person.fill")!
        }
        return UIImage(systemName: "person.fill")!
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
