
import UIKit
import Firebase
import SDWebImage

class tblUsuariosCelda:UITableViewCell {
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
}

class VCListaUsuarios: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblUsuarios: UITableView!
    
    var usuarios:[Usuario] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblUsuarios.delegate = self
        tblUsuarios.dataSource = self
       
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
            self.tblUsuarios.reloadData()
            
            //self.imagenPerfil.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        })
        
        Database.database().reference().child("usuarios").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for usuario in self.usuarios{
                if usuario.uid == snapshot.key{
                    self.usuarios.remove(at: iterator)
                }
                iterator += 1
            }
            self.tblUsuarios.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tblUsuarios.dequeueReusableCell(withIdentifier: "usuarios", for: indexPath) as! tblUsuariosCelda
        let usuario = usuarios[indexPath.row]

        celda.lblNombre?.text = usuario.nombre
        celda.lblTipo?.text = usuario.tipo
        celda.lblEmail?.text = usuario.correo
        celda.imagenPerfil?.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        celda.imagenPerfil.backgroundColor = UIColor.clear
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verUsuarioSegue", sender:usuarios[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verUsuarioSegue" {
            let siguienteVC = segue.destination as! VCVerUsuario
            siguienteVC.usuario = sender as! Usuario
            
        }
    }

}
