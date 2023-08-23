import Foundation
import UIKit

struct showAlertStruct{
    static let shared = showAlertStruct()
    
    //showAlert
    func showAlert(title: String, message: String? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
           alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
       }
}
