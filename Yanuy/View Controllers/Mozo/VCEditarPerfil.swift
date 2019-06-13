
import UIKit
import Firebase
import SDWebImage

class VCEditarPerfil: UIViewController {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnCambiarImagen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((Auth.auth().currentUser?.uid)!)
        
        //let datos = ["nombre" : self.txtNombre.text!, "correo" : self.txtCorreo.text!, "tipo" : self.txtTipo.text!] as [String : Any]
        
        //let ref = Database.database().reference().child("usuarios").child(usuario.uid)
        
        /*print("hola ==>>> \(ref)")
        ref.updateChildValues(datos)*/
        
    }
    
    @IBAction func btnEditarTapped(_ sender: Any) {
        
        btnGuardar.isHidden = false
        btnCancelar.isHidden = false
        btnCambiarImagen.isHidden = false
        
        txtNombre.isEnabled = true
        
    }
    
    @IBAction func btnCambiarImagenTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
    }
    
    @IBAction func btnCancelarTapped(_ sender: Any) {
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        btnCambiarImagen.isHidden = true

        txtNombre.isEnabled = false
        /*
        txtNombre.text! = usuario.nombre
        txtTipo.text! = usuario.tipo
        txtCorreo.text! = usuario.correo*/
    }
}
