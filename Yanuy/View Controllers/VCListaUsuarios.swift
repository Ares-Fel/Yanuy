
import UIKit

class tblUsuariosCelda:UITableViewCell {
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
}

class VCListaUsuarios: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblUsuarios: UITableView!
    
    //var usuarios = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUsuarios.delegate = self
        tblUsuarios.dataSource = self
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tblUsuarios.dequeueReusableCell(withIdentifier: "usuarios", for: indexPath) as! tblUsuariosCelda
        celda.lblNombre?.text = "Willy Baldeón"
        celda.lblTipo?.text = "Tipo: Mozo"
        celda.lblEmail?.text = "email: willy.baldeon@yanuy.com"
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verUsuarioSegue", sender: nil)
    }

}
