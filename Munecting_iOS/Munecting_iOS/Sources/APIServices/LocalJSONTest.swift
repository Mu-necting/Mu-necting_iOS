
import Foundation

struct localJSONTest{
    static let shared = localJSONTest()
    
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
    
}

