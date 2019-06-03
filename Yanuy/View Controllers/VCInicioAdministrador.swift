
import UIKit

class VCInicioAdministrador: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func btnUsuariosTapped(_ sender: Any) {
        performSegue(withIdentifier: "listaUsuariosSegue", sender: nil)
    }
    
    @IBAction func btnListarCartaTapped(_ sender: Any) {
        performSegue(withIdentifier: "listaCartaSegue", sender: nil)
    }
}
