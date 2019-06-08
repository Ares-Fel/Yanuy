
import UIKit
import Firebase
import SDWebImage

class VCVerUsuario: UIViewController {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    var usuario = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        
        txtNombre.text! = usuario.nombre
        txtTipo.text! = usuario.tipo
        txtCorreo.text! = usuario.correo
        imagenPerfil.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        
    }

    @IBAction func btnEliminarTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditarTapped(_ sender: Any) {
        btnGuardar.isHidden = false
        btnCancelar.isHidden = false
        
        txtNombre.isEnabled = true
        txtTipo.isEnabled = true
        txtCorreo.isEnabled = true
    }
    @IBAction func btnGuardarTapped(_ sender: Any) {
        /*let ref = Database.database().reference().child("usuarios/\(usuario.uid)")
        
        let alerta = UIAlertController(title: "¡HECHO!", message: "El usuario fue creado exitosamente.", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alerta, animated: true, completion: nil)
        
        let datos = ["nombre" : self.txtNombre.text!, "correo" : user!.user.email, "tipo" : self.txtTipo.text!, "fotoURL" : fotoURL?.absoluteString, "fotoID" : self.fotoID]
        Database.database().reference().child("usuarios").child(user!.user.uid).setValue(datos)
   */ }
    
    @IBAction func btnCancelarTapped(_ sender: Any) {
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        
        txtNombre.isEnabled = false
        txtTipo.isEnabled = false
        txtCorreo.isEnabled = false
        
        txtNombre.text! = usuario.nombre
        txtTipo.text! = usuario.tipo
        txtCorreo.text! = usuario.correo
    }
}
