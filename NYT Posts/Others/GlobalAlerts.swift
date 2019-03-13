//
//  GlobalAlerts.swift
//

import UIKit

class GlobalAlerts: NSObject {
    
    static func showAlertWithTitleAndAction(_ vc:UIViewController, title: String, message:String, closure: @escaping (_ action: Bool) -> Void){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            closure(true)
        }))
        
        
        vc.present(refreshAlert, animated: true, completion: nil)
        
    }
    
}
