
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
            
            var mensaje = "Para continuar, ingrese el número de la mesa:"
            
            if fondos == "" {
                mensaje = "No ha seleccionado ningún fondo. ¿Está seguro de continuar?"
            }
            
            let alerta = UIAlertController(title: "Título original e ingenioso", message: mensaje, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Continuar", style: .default) {
                (UIAlertAction) in
                let textField = alerta.textFields![0] as UITextField
                self.confirmar(nroMesa: textField.text!)
                
            }
            
            alerta.addTextField { (textField) in
                textField.placeholder = "Número de mesa"
                
            }
            
            alerta.addAction(action)
            
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEditar(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func confirmar(nroMesa:String){
        if Double(nroMesa)! > 0  {
            
            let confirmacion = UIAlertController(title: "Confirmar Pedido", message: "Se registrará el pedido para la mesa \(nroMesa). ¿Está seguro?", preferredStyle: .alert)
            confirmacion.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            confirmacion.addAction(UIAlertAction(title: "Si", style: .default, handler: {(UIAlertAction) in
                
                let fecha = Date()
                let calendar = Calendar.current
                 
                let año = calendar.component(.year, from: fecha)
                let mes = calendar.component(.month, from: fecha)
                let dia = calendar.component(.day, from: fecha)
                let hora = calendar.component(.hour, from: fecha)
                let minuto = calendar.component(.minute, from: fecha)
                let segundo = calendar.component(.second, from: fecha)
                
                let ref = Database.database().reference().child("pedidos").child(self.pedido.id)
                ref.updateChildValues(["estado" : "pendiente", "nroMesa" : "\(nroMesa)", "fecha" : "\(año)/\(dia)\(mes)", "hora" : "\(hora):\(minuto):\(segundo)"])
                self.notificar()
                
                }))
            
            self.present(confirmacion, animated: true, completion: nil)
        } else {
            print("No mms pdnjo, pon un número")
        }
    }
    
    func notificar(){
        let notificacion = UIAlertController(title: "¡HECHO!", message: "El pedido fue enviado al Chef con éxito.", preferredStyle: .alert)
        
        notificacion.addAction(UIAlertAction(title: "Entendido", style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(notificacion, animated: true, completion: nil)
    }
}
