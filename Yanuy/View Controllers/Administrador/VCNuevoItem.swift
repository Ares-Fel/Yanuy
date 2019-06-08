
import UIKit
import Firebase

class VCNuevoItem: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var imagenItem: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtStock: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    let item = Item()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

    }
    
    @IBAction func btnAgregarImagen(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        if(!txtNombre.text!.isEmpty && !txtTipo.text!.isEmpty && !txtPrecio.text!.isEmpty){
            
            //Almacenar imagen
            let imagenesFolder = Storage.storage().reference().child("imagenesitems")
            let imagenData = self.imagenItem.image?.jpegData(compressionQuality: 0.50)
            let cargarImagen = imagenesFolder.child("\(self.imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata:nil) { (metadata, error) in
                if error != nil {
                    self.mostrarError(error: String(describing: error))

                } else {
                    cargarImagen.downloadURL(completion: { (imagenURL, error) in
                        if error != nil {
                            self.mostrarError(error: String(describing: error))

                            return
                            
                        } else {
                            //Mostrar Alerta
                            let alerta = UIAlertController(title: "¡HECHO!", message: "El item fue creado exitosamente.", preferredStyle: .alert)
                            
                            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            self.present(alerta, animated: true, completion: nil)
                            
                            self.item.nombre = self.txtNombre.text!
                            self.item.tipo = self.txtTipo.text!
                            self.item.precio = self.txtPrecio.text!
                            self.item.stock = self.txtStock.text!
                            self.item.imagenURL = (imagenURL?.absoluteString)!
                            self.item.imagenID = self.imagenID
                            
                            let datos = ["nombre" : self.item.nombre,
                                         "tipo" : self.item.tipo,
                                         "precio" : self.item.precio,
                                         "stock" : self.item.stock,
                                         "imagenURL" : self.item.imagenURL,
                                         "imagenID" : self.item.imagenID,
                                         "menu" : self.item.menu] as [String : Any]
                            Database.database().reference().child("items").childByAutoId().setValue(datos)
                        }
                    })
                }
            }
        } else {
            let alerta = UIAlertController(title: "¡ERROR!", message: "Debe llenar todos los campos.", preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelarTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagenItem.image = image
        imagenItem.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarError(error:String){
        let alerta = UIAlertController(title: "¡ERROR!", message: "No se pudo crear el item: \(error). Verifique su conexión a Internet y vuelva a intentarlo", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
