
import UIKit

class VCInicioAdministrador: UIViewController {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var imagenMenu: UIImageView!
    @IBOutlet weak var imagenUsuarios: UIImageView!
    var usuario = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenMenu.image = UIImage(named: "menu")
        imagenUsuarios.image = UIImage(named: "usuarios")
        //imagenCarta.image = UIImage(named: "carta")
    }
    
}
