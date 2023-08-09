import Foundation
import UIKit

struct Music{
    let name: String
    let coverImage: String
    let genre: String
    let musicPre: String
    let musicPull: String
    let replyCnt: Int
    let archiveId: Int
}



/*
 @IBAction func nextMusicButtonTapped(_ sender: Any) {
     let musicURL = URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a")
     self.audioPlayer =  AVPlayer(url: musicURL!)
     self.audioPlayer?.play()
     let albumImage = getImage(url: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg")!)
     self.albumCoverImageView.image = albumImage
     self.backgroundImageView.image = albumImage.applyBlur(radius: 2.0)
     self.musicTitle.text = "Attention"
     self.artistNameLabel.text = "New Jeans"
     self.genreLabel.text = "#K-POP"
 }
 */
