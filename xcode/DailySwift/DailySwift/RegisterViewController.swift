//
//  RegisterViewController.swift
//  DailySwift
//
//  Created by 이시현 on 2021/09/29.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func completBtn(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: pwTextField.text!

        ) { (user, error) in

            if user !=  nil{

                print("register success")

            }

            else{

                print("register failed")

            }

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
