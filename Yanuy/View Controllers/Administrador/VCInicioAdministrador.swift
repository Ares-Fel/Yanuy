
import UIKit

class VCInicioAdministrador: UIViewController {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var imagenMenu: UIImageView!
    @IBOutlet weak var imagenUsuarios: UIImageView!
    @IBOutlet weak var labelCarta: UIButton!
    @IBOutlet weak var labelMenu: UIButton!
    @IBOutlet weak var labelUsuarios: UIButton!
    var usuario = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagenCarta.layer.masksToBounds = true
        imagenCarta.layer.cornerRadius = 75
        
        imagenMenu.layer.masksToBounds = true
        imagenMenu.layer.cornerRadius = 75
        
        imagenUsuarios.layer.masksToBounds = true
        imagenUsuarios.layer.cornerRadius = 75
        
        /*labelCarta.layer.masksToBounds = true
        labelCarta.layer.cornerRadius = 75
        
        labelMenu.layer.masksToBounds = true
        labelMenu.layer.cornerRadius = 75
        
        labelUsuarios.layer.masksToBounds = true
        labelUsuarios.layer.cornerRadius = 75*/
    }
    
}
