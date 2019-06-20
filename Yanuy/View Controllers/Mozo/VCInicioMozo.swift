
import UIKit
import Firebase

class VCInicioMozo: UIViewController {

    var usuarios:[Usuario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: { (snapshot) in
            print("AQUI: \(snapshot)")
            
            let usuario = Usuario()
            usuario.correo = (snapshot.value as! NSDictionary)["correo"] as! String
            usuario.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            usuario.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            usuario.fotoURL = (snapshot.value as! NSDictionary)["fotoURL"] as! String
            usuario.fotoID = (snapshot.value as! NSDictionary)["fotoID"] as! String
            usuario.uid = snapshot.key
            
            self.usuarios.append(usuario)
            
            //self.imagenPerfil.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        })

    }

    @IBAction func btnNuevoPedidoTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "nuevoPedidoSegue", sender: usuarios)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditarPerfil"{
            let siguienteVC = segue.destination as! VCEditarPerfil
            siguienteVC.usuario = sender as! Usuario
        }else if segue.identifier == "segueNuevoPedido"{
            let siguienteVC = segue.destination as! VCNuevoPedido
        }
    }
}
