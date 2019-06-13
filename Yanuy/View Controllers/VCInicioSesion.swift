
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
            
             print("Intentando iniciar sesion \(user?.user.uid)")
            
             if error != nil {
                let alerta = UIAlertController(title: "¡ERROR!", message: "Las credenciales son inválidas. Intente nuevamente.", preferredStyle: .alert)
                
                alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alerta, animated: true, completion: nil)
                
             } else{
                
                let usuario = Usuario()
                Database.database().reference().child("usuarios").child((user?.user.uid)!).observe(DataEventType.value, with: { (snapshot) in
                    
                    usuario.correo = (snapshot.value as! NSDictionary)["correo"] as! String
                    usuario.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
                    usuario.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
                    usuario.fotoURL = (snapshot.value as! NSDictionary)["fotoURL"] as! String
                    usuario.fotoID = (snapshot.value as! NSDictionary)["fotoID"] as! String
                    usuario.uid = snapshot.key
                    
                    if usuario.tipo == "Mozo" {
                        self.performSegue(withIdentifier: "inicioMozoSegue", sender: usuario)

                    } else if usuario.tipo == "Chef" {
                        let alerta = UIAlertController(title: "¡ATENCIÓN!", message: "Usted debe usar la aplicación YanuyChef.", preferredStyle: .alert)
                        
                        alerta.addAction(UIAlertAction(title: "AEA, oc", style: .default, handler: {(UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alerta, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "inicioAdministradorSegue", sender: usuario)
                    }
                    
                })
             }
            
         }
        
    }
    
    @IBAction func btnIngresarMozoTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "inicioMozoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inicioMozoSegue" {
            let siguienteVC = segue.destination as! VCInicioMozo
            siguienteVC.usuario = sender as! Usuario
        }else if segue.identifier == "inicioAdministradorSegue" {
            let siguienteVC = segue.destination as! VCInicioAdministrador
            siguienteVC.usuario = sender as! Usuario
        }
    }
    
}

