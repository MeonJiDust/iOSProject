//
//  LoginViewController.swift
//  DailySwift
//
//  Created by 이시현 on 2021/09/28.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func loginBtn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in

                    if user != nil{

                        print("login success")

                    }

                    else{

                        print("login fail")

                    }

              }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = Auth.auth().currentUser{
            
            emailTextField.placeholder = "이미 로그인 된 상태입니다."
            pwTextField.placeholder = "이미 로그인 된 상태입니다."
        }


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

