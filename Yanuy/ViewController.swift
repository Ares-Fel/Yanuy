//
//  ViewController.swift
//  Yanuy
//
//  Created by MAC19 on 27/05/19.
//  Copyright © 2019 OscarMolleapaza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    
    
    @IBAction func btnIngresar(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtUsuario.text!, password: txtContraseña.text!) { (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento un error")
            }
            else{
                print("Sesion iniciada")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

