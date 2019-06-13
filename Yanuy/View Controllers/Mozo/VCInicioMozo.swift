
import UIKit

class VCInicioMozo: UIViewController {

    var usuario = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnNuevoPedidoTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "nuevoPedidoSegue", sender: nil)
    }
}
