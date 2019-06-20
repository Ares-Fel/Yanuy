
import UIKit
import Firebase
import SDWebImage

class VCEditarPerfil: UIViewController {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnCambiarImagen: UIButton!
    
    var usuario = Usuario()
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
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
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        
        if imagenID != usuario.uid {
            print("ids diferentes: \(imagenID) == \(usuario.uid)")
            Storage.storage().reference().child("imagenesitems").child("\(self.usuario.uid).jpg").delete { (error) in ///ELIMINAR LA IMG EN STORAGE
                print("Se ha eliminado el item correctamente")
            }
            
            //------Almacenar imagen-----//
            let imagenesFolder = Storage.storage().reference().child("imagenesitems")
            let imagenData = self.imagenPerfil.image?.jpegData(compressionQuality: 0.50)
            let cargarImagen = imagenesFolder.child("\(self.imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata:nil) { (metadata, error) in
                if error != nil {
                    self.mostrarError(error: String(describing: error))
                    
                } else {
                    cargarImagen.downloadURL(completion: { (imagenURL, error) in
                        if error != nil {
                            self.mostrarError(error: String(describing: error))
                            return
                            
                        } else {//Actualizar datos en daatabase
                            
                            let datos = ["imagenID": self.imagenID,
                                         "imagenURL" : (imagenURL?.absoluteString)!] as [String : Any]
                            
                            Database.database().reference().child("usuarios").child(self.usuario.uid).updateChildValues(datos)
                            
                            let alerta = UIAlertController(title: "¡HECHO!", message: "El item se modificó correctamente.", preferredStyle: .alert)
                            
                            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            self.present(alerta, animated: true, completion: nil)
                        }
                    })
                }
            }
            
        }else{
            
            let alerta = UIAlertController(title: "¡HECHO!", message: "El item se modificó correctamente.", preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alerta, animated: true, completion: nil)
        }
        
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
    func mostrarError(error:String){
        let alerta = UIAlertController(title: "¡ERROR!", message: "No se pudo crear el item: \(error). Verifique su conexión a Internet y vuelva a intentarlo", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
