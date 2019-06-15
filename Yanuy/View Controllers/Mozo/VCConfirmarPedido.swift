
import UIKit
import Firebase

class VCConfirmarPedido: UIViewController {

    @IBOutlet weak var txtEntradas: UITextView!
    @IBOutlet weak var txtFondos: UITextView!
    @IBOutlet weak var txtPostres: UITextView!
    
    var entradas = ""
    var fondos = ""
    var postres = ""
    
    var pedido = Pedido() //Para realizar la consulta
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("pedidos").child(pedido.id).child("contenido").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let contenido = Contenido()
            contenido.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            contenido.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            contenido.cantidad = (snapshot.value as! NSDictionary)["cantidad"] as! Int
            contenido.id = snapshot.key
            
            //Según el tipo, agregamos cada nombre en la variable correspondiente
            if contenido.tipo == "Entrada" {
                self.entradas += "\(contenido.nombre) \(contenido.cantidad)\n"
            } else if contenido.tipo == "Fondo" {
                self.fondos += "\(contenido.nombre) \(contenido.cantidad)\n"
            } else {
                self.postres += "\(contenido.nombre) \(contenido.cantidad)\n"
            }
            
            self.txtEntradas.text! = self.entradas
            self.txtFondos.text! = self.fondos
            self.txtPostres.text! = self.postres
        })
    }
    @IBAction func btnConfirmar(_ sender: Any) {
        
        if self.entradas == "" && self.fondos == "" && self.postres == "" {
            
            let alerta = UIAlertController(title: "¡Atención!", message: "¡No puede realizar un pedido vacío!", preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)

        } else {
            
            var mensaje = "¿Está seguro de realizar el pedido?"
            
            if fondos == "" {
                mensaje = "No ha seleccionado ningún fondo. ¿Está seguro de continuar?"
            }
            let alerta = UIAlertController(title: "Confirmar Pedido", message: mensaje, preferredStyle: .alert)

            alerta.addAction(UIAlertAction(title: "No", style: .cancel))
            alerta.addAction(UIAlertAction(title: "Si", style: .default, handler: {(UIAlertAction) in
                print("GG") //Aquí va el codigo :v
                
                /*
                do {
                    //for i in self.menu {
                    
                    //}
                    
                    let alerta = UIAlertController(title: "¡HECHO!", message: "El menú se modificó satisfactoriamente.", preferredStyle: .alert)
                    
                    alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(alerta, animated: true, completion: nil)
                    
                } catch { print("Ocurrió un error.") }*/
            }))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEditar(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
