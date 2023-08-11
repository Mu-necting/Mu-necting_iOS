//
//  MusicSearchViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/03.
//

import UIKit



class MusicSearchViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    var searchDataList:[MusicSearchData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchData()
    }
    
    func getImage(url: URL)-> UIImage{
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {return image}
        }else{
            return UIImage()
        }
        return UIImage()
    }
    
    func searchData(){
        let newJeansURL = URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/60x60bb.jpg")
        let chaliputhURL = URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/60x60bb.jpg")
        let dojacatURL = URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music116/v4/26/fe/b2/26feb2d2-c11b-cf95-4b93-d57321103566/196871142090.jpg/60x60bb.jpg")
        let sebadohURL = URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music/d5/80/bd/mzi.nybhumzg.tif/60x60bb.jpg")
        
        searchDataList.append(MusicSearchData(albumImage: getImage(url: newJeansURL!), albumTitle: "Attention", artist: "NewJeans"))
        searchDataList.append(MusicSearchData(albumImage: getImage(url: chaliputhURL!), albumTitle: "Attention", artist: "Chalie Puth"))
        searchDataList.append(MusicSearchData(albumImage: getImage(url: dojacatURL!), albumTitle: "Attention", artist: "Doja Cat"))
        searchDataList.append(MusicSearchData(albumImage: getImage(url: sebadohURL!), albumTitle: "Attention", artist: "Sebadoh"))
        self.searchTextField.text = ""
        self.collectionView.reloadData()
    }
    

    //collectionView설정
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension MusicSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSearchCollectionViewCell", for: indexPath) as? MusicSearchCollectionViewCell else {return UICollectionViewCell()}
        cell.albumImageView.image = searchDataList[indexPath.row].albumImage
        cell.artistLabel.text = searchDataList[indexPath.row].artist
        cell.musicTitleLabel.text = searchDataList[indexPath.row].albumTitle
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Upload", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "UploadViewController") as? UploadViewController else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MusicSearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 30, height: 80)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
