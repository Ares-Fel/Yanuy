
import UIKit
import Firebase

class VCInicioSesion: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnIngresarTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtUsuario.text!, password: txtContraseña.text!) { (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento un error")
                self.performSegue(withIdentifier: "inicioMozoSegue", sender: nil)
            }
            else{
                print("Sesion iniciada")
                self.performSegue(withIdentifier: "inicioAdministradorSegue", sender: nil)
            }
        }
    }
}

