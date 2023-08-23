
import Foundation

struct localJSONTest{
    static let shared = localJSONTest()
    struct EmptyResult: Codable {}
    
    
    func loadAroundMusicJSON(){
        if let path = Bundle.main.path(forResource: "arroundMusic", ofType: "json") {
            do {
                print("============loadAroundMusicJSON===============")
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                print("============loadAroundMusicJSON===============")
                let response = try decoder.decode(GenericResponse<[AroundMusic]>.self, from: jsonData)
                print("============loadAroundMusicJSON===============")
                print("Is Success:", response.isSuccess)
                print("Code:", response.code)
                print("Message:", response.message)
                print("Music Items:", response.result[0])
                print("============loadAroundMusicJSON===============")
            } catch {
                print("Error:", error)
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func munectingMapJSON(){
        if let path = Bundle.main.path(forResource: "MunectingMapBlankResult", ofType: "json") {
            do {
                print("============munectingMapJSON===============")
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                
                print("============munectingMapJSON===============")
                let response = try decoder.decode(GenericResponse<[MunectingMapData]>.self, from: jsonData)
                print("============munectingMapJSON===============")
                print("Is Success:", response.isSuccess)
                print("Code:", response.code)
                print("Message:", response.message)
//                print("Music Items:", response.result[0])
                print("============munectingMapJSON===============")
            } catch {
                print("Error:", error)
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func searchMusicJSON(){
        if let path = Bundle.main.path(forResource: "musicSearch2", ofType: "json") {
            do {
                print("============searchMusicJSON===============")
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                print("============searchMusicJSON===============")
                let response = try decoder.decode(GenericResponse<MusicSearchResult>.self, from: jsonData)
                print("============loadAroundMusicJSON===============")
                print(response.isSuccess)
                print(response.result.musicSearchRes[0])
                print("============searchMusicJSON===============")
            } catch {
                print("Error:", error)
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    func uploadMusicJSON(){
        if let path = Bundle.main.path(forResource: "emptyResult", ofType: "json") {
            do {
                print("============uploadMusicJSON===============")
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                print("============uploadMusicJSON===============")
                let response = try decoder.decode(SimpleResponse.self, from: jsonData)
                print("============uploadMusicJSON===============")
                print(response.isSuccess)
                print("============uploadMusicJSON===============")
            } catch {
                print("Error:", error)
            }
        } else {
            print("JSON file not found.")
        }
    }
    
}

