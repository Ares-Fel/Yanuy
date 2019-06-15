
import UIKit
import Firebase

class VCConfirmarMenu: UIViewController{
    
    @IBOutlet weak var txtEntradas: UITextView!
    @IBOutlet weak var txtFondos: UITextView!
    @IBOutlet weak var txtPostres: UITextView!
    
    var items = [
        [Item()],
        [Item()],
        [Item()]
    ]
    
    var menu:[Item] = []

    var entradas = ""
    var fondos = ""
    var postres = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for i in items{
            for j in i{
                if j.menu == true {
                    menu.append(j)
                    if j.tipo == "Entrada"{
                        entradas += " - \(j.nombre)\n"
                    }else if j.tipo == "Fondo"{
                        fondos += " - \(j.nombre)\n"
                    }else{
                        postres += " - \(j.nombre)\n"
                    }
                }
            }
        }
        
        txtEntradas.text! = entradas
        txtFondos.text! = fondos
        txtPostres.text! = postres
    }
    
    @IBAction func btnEditar(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirmar(_ sender: Any) {
        
        if self.entradas == "" || self.fondos == "" || self.postres == "" {
            
            var mensaje = ""
            
            if entradas=="" { mensaje = "No ha seleccionado ninguna entrada. ¿Está seguro de continuar?" }
            else if fondos=="" { mensaje = "No ha seleccionado ningún fondo. ¿Está seguro de continuar?" }
            else if postres=="" { mensaje = "No ha seleccionado ningún postre. ¿Está seguro de continuar?" }

            let alerta = UIAlertController(title: "¡Atención!", message: mensaje, preferredStyle: .alert)
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))

            alerta.addAction(UIAlertAction(title: "Guardar Menú", style: .default, handler: {(UIAlertAction) in
                print("GG")
            }))
            
            self.present(alerta, animated: true, completion: nil)
            
        } else {
            
            do {
                for i in self.menu {
                    
                }
                
                let alerta = UIAlertController(title: "¡HECHO!", message: "El menú se modificó satisfactoriamente.", preferredStyle: .alert)
                
                alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alerta, animated: true, completion: nil)
                
            } catch { print("Ocurrió un error.") }
        }
    }
}
