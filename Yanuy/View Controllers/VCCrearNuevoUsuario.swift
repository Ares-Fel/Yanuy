
import UIKit
import Firebase

class VCCrearNuevoUsuario: UIViewController {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var txtContraseña1: UITextField!
    @IBOutlet weak var txtContraseña2: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    var fotoID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        if(txtContraseña1.text!.isEqual(txtContraseña2.text!) && !txtCorreo.text!.isEmpty
                                    && !txtTipo.text!.isEmpty && !txtNombre.text!.isEmpty){
            
            Auth.auth().createUser(withEmail: self.txtCorreo.text!, password: self.txtContraseña1.text!, completion: { (user, error) in
                print("Intentando crear un usuario")
                
                if error != nil {
                    self.mostrarError(error: String(describing: error))

                } else {
                    
                    //Almacenar imagen
                    let imagenesFolder = Storage.storage().reference().child("fotosperfil")
                    let imagenData = self.imagenPerfil.image?.jpegData(compressionQuality: 0.50)
                    let cargarImagen = imagenesFolder.child("\(self.fotoID).jpg")
                    cargarImagen.putData(imagenData!, metadata:nil) { (metadata, error) in
                        if error != nil {
                            self.mostrarError(error: String(describing: error))

                        } else {
                            cargarImagen.downloadURL(completion: { (fotoURL, error) in
                                if error != nil {
                                    self.mostrarError(error: String(describing: error))
                                    return
                                    
                                } else {
                                    
                                    //Mostrar Alerta
                                    let alerta = UIAlertController(title: "¡HECHO!", message: "El usuario fue creado exitosamente.", preferredStyle: .alert)
                                    
                                    alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    
                                    self.present(alerta, animated: true, completion: nil)
                                    
                                    let datos = ["nombre" : self.txtNombre.text!, "correo" : user!.user.email, "tipo" : self.txtTipo.text!, "fotoURL" : fotoURL?.absoluteString, "fotoID" : self.fotoID]
                                    Database.database().reference().child("usuarios").child(user!.user.uid).setValue(datos)
                                    
                                }
                            })
                        }
                    }
                    
                    
                }
            })
            
        } else {
            let alerta = UIAlertController(title: "¡ERROR!", message: "Las contraseñas no coinciden.", preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
    
    }

    func mostrarError(error:String){
        let alerta = UIAlertController(title: "¡ERROR!", message: "No se pudo crear el usuario: \(error). Verifique su conexión a Internet y vuelva a intentarlo", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
