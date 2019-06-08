
import UIKit
import Firebase
import SDWebImage

class tblCartaCelda: UITableViewCell {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    
}

class VCListaItems: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblCarta: UITableView!
    
    var items:[Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblCarta.delegate = self
        tblCarta.dataSource = self

        Database.database().reference().child("items").observe(DataEventType.childAdded, with: { (snapshot) in
            print("AQUI: \(snapshot)")
            
            let item = Item()
            item.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            item.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            item.precio = (snapshot.value as! NSDictionary)["precio"] as! String
            item.stock = (snapshot.value as! NSDictionary)["stock"] as! String
            item.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            item.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            item.menu = (snapshot.value as! NSDictionary)["menu"] as! Bool
            item.id = snapshot.key
            
            self.items.append(item)
            self.tblCarta.reloadData()
            
            //self.imagenPerfil.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tblCarta.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblCartaCelda
        let item = items[indexPath.row]
        
        celda.lblNombre?.text = item.nombre
        celda.lblTipo?.text = "Tipo: \(item.tipo)"
        celda.lblPrecio?.text = "Precio: S/\(item.precio)"
        
        if item.stock != "" { celda.lblStock?.text = "Stock: \(item.stock)" }
        
        celda.lblStock?.text = item.stock
        celda.imagenCarta?.sd_setImage(with: URL(string: item.imagenURL), completed: nil)
        celda.imagenCarta.backgroundColor = UIColor.clear
        
        return celda
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verItemSegue", sender:items[indexPath.row])
    }
    

}
