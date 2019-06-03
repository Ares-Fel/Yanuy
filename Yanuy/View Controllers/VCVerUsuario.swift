
import UIKit

class VCVerUsuario: UIViewController {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
    }

    @IBAction func btnEliminarTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditarTapped(_ sender: Any) {
        btnGuardar.isHidden = false
        btnCancelar.isHidden = false
        
        txtNombre.isEnabled = true
        txtTipo.isEnabled = true
        txtCorreo.isEnabled = true
    }
    @IBAction func btnGuardarTapped(_ sender: Any) {
    }
    @IBAction func btnCancelarTapped(_ sender: Any) {
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        
        txtNombre.isEnabled = false
        txtTipo.isEnabled = false
        txtCorreo.isEnabled = false
    }
}
