//import Alamofire
//import Foundation
//
//struct decodingTestMusicSearch{
//    static let shared = decodingTestMusicSearch()
//    
//    
//    
//    func loadJSON(){
//        let path = Bundle.main.url(forResource: "musicSearch", withExtension: "json")
//        let decoder = JSONDecoder()
//
//        do{
//            let jsonData = try Data(contentsOf: path!, options: Data.ReadingOptions.mappedIfSafe)
//            guard let decodedData = try? decoder.decode(MusicSearchData.self, from: jsonData) else {return}
//            print(decodedData)
//        }catch{
//            print("error1")
//        }
//            print("error2")
//    }
//    
//    
//}
