
import UIKit
import Firebase

class VCConfirmarMenu: UIViewController{

    @IBOutlet weak var tblConfirmar: UITableView!
    @IBOutlet weak var txtEntradas: UITextView!
    @IBOutlet weak var txtFondos: UITextView!
    @IBOutlet weak var txtPostres: UITextView!
    
    var items = [
        [Item()],
        [Item()],
        [Item()]
    ]
    
    var entradas:[String] = []
    var fondos:[String] = []
    var postres:[String] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for i in items{
            for j in i{
                if j.tipo == "Entrada"{
                    entradas.append(j.nombre)
                }else if j.tipo == "Fondo"{
                    fondos.append(j.nombre)
                }else{
                    postres.append(j.nombre)
                }
            }
        }

    }

}
