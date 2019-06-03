
import UIKit

class VCVerCarta: UIViewController {

    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var txtStock: UITextField!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    
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
        txtStock.isEnabled = true
        txtPrecio.isEnabled = true
    }
    
    @IBAction func btnGuardarTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnCancelarTapped(_ sender: Any) {
        btnGuardar.isHidden = true
        btnCancelar.isHidden = true
        
        txtNombre.isEnabled = false
        txtTipo.isEnabled = false
        txtStock.isEnabled = false
        txtPrecio.isEnabled = false
    }
    
}
