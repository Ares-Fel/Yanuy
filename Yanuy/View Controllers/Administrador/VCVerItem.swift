
import UIKit
import SDWebImage
import Firebase

class VCVerItem: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var txtStock: UITextField!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var btnEditarImg: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenID = item.imagenID
        
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        btnEditarImg.isHidden = true
        
        imagePicker.delegate = self
        
        txtNombre.text = item.nombre
        txtTipo.text = item.tipo
        txtPrecio.text = item.precio
        txtStock.text = item.stock
        imagen.sd_setImage(with: URL(string: item.imagenURL), completed: nil)
        imagen.layer.masksToBounds = true
        imagen.layer.cornerRadius = 5

     //   celda.imagenCarta?.sd_setImage(with: URL(string: item.imagenURL), completed: nil)

    }

    @IBAction func btnEliminarTapped(_ sender: Any) {
        let ref = Database.database().reference().child("items").child(item.id)
        
        let alerta = UIAlertController(title: "¡Atención!", message: "¿Realmente desea elminar este item?", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
            
            ref.removeValue()
            Storage.storage().reference().child("imagenesitems").child("\(self.item.imagenID).jpg").delete { (error) in
                print("Se ha eliminado el item correctamente")
                
                self.navigationController?.popViewController(animated: true)
            }
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnEditarTapped(_ sender: Any) {
        btnGuardar.isHidden = false
        btnCancelar.isHidden = false
        btnEditarImg.isHidden = false
        
        txtNombre.isEnabled = true
        txtTipo.isEnabled = true
        //txtStock.isEnabled = true
        txtPrecio.isEnabled = true
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        
        if(!txtNombre.text!.isEmpty && !txtTipo.text!.isEmpty && !txtPrecio.text!.isEmpty){
            
            if imagenID != item.imagenID {
                print("ids diferentes: \(imagenID) == \(item.imagenID)")
                Storage.storage().reference().child("imagenesitems").child("\(self.item.imagenID).jpg").delete { (error) in ///ELIMINAR LA IMG EN STORAGE
                        print("Se ha eliminado el item correctamente")
                    }
                
                //------Almacenar imagen-----//
                let imagenesFolder = Storage.storage().reference().child("imagenesitems")
                let imagenData = self.imagen.image?.jpegData(compressionQuality: 0.50)
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
                                             "imagenURL" : (imagenURL?.absoluteString)!,
                                             "nombre" : self.txtNombre.text!,
                                             "tipo" : self.txtTipo.text!,
                                             "precio" : self.txtPrecio.text!] as [String : Any]
                                
                                Database.database().reference().child("items").child(self.item.id).updateChildValues(datos)
                                
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
                print("ids iguales: \(imagenID) == \(item.imagenID)")
                let datos = ["nombre" : self.txtNombre.text!, "tipo" : self.txtTipo.text!, "precio" : self.txtPrecio.text!] as [String : Any]
                
                let ref = Database.database().reference().child("items").child(item.id)
                
                ref.updateChildValues(datos)
                
                let alerta = UIAlertController(title: "¡HECHO!", message: "El item se modificó correctamente.", preferredStyle: .alert)
                
                alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alerta, animated: true, completion: nil)
            }
            
        } else {
            let alerta = UIAlertController(title: "¡ERROR!", message: "Debe llenar todos los campos.", preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        //////////////----------------------------/
        
        
    }
    
    @IBAction func btnCancelarTapped(_ sender: Any) {
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        
        txtNombre.isEnabled = false
        txtTipo.isEnabled = false
        txtStock.isEnabled = false
        txtPrecio.isEnabled = false
        
        txtNombre.text! = item.nombre
        txtTipo.text! = item.tipo
        txtPrecio.text! = item.precio
    }
    
    @IBAction func btnEditarImgTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagen.image = image
        imagen.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
        imagenID = NSUUID().uuidString
    }
    
    func mostrarError(error:String){
        let alerta = UIAlertController(title: "¡ERROR!", message: "No se pudo crear el item: \(error). Verifique su conexión a Internet y vuelva a intentarlo", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
