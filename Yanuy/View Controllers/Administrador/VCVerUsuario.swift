
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
        imagenPerfil.layer.masksToBounds = true
        imagenPerfil.layer.cornerRadius = 5
        
    }

    @IBAction func btnEliminarTapped(_ sender: Any) {
        
        let ref = Database.database().reference().child("usuarios").child(usuario.uid)
        
        let alerta = UIAlertController(title: "¡Atención!", message: "¿Realmente desea elminar este usuario?", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
            
            ref.removeValue()
            Storage.storage().reference().child("fotosperfil").child("\(self.usuario.fotoID).jpg").delete { (error) in
                print("Se ha eliminado al usuario correctamente")
                
                self.navigationController?.popViewController(animated: true)
            }
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnEditarTapped(_ sender: Any) {
        btnGuardar.isHidden = false
        btnCancelar.isHidden = false
        
        txtNombre.isEnabled = true
        txtTipo.isEnabled = true
        txtCorreo.isEnabled = true
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        
        let datos = ["nombre" : self.txtNombre.text!, "correo" : self.txtCorreo.text!, "tipo" : self.txtTipo.text!] as [String : Any]
        
        let ref = Database.database().reference().child("usuarios").child(usuario.uid)
        
        print("hola ==>>> \(ref)")
        ref.updateChildValues(datos)
        
        let alerta = UIAlertController(title: "¡HECHO!", message: "Los datos del usuario se modificaron exitosamente.", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alerta, animated: true, completion: nil)
    }
    
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
