
import UIKit
import Firebase
import SDWebImage

class tblMenuCelda:UITableViewCell{
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var marca: UIImageView!
    
}

class VCListaMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblMenu: UITableView!
    var secciones = ["Entradas", "Fondos", "Postres"]
    
    /*var items = [
        ["Salpicón", "Caldo Blanco", "Soltero de Queso"],
        ["Arroz con Pato", "Ají de Gallina", "Lomo Saltado", "Hígado Frito", "Pescado Frito"],
        ["Torta de Chocolate","Flan","Helado de Fresa"]
    ]*/
    
    var items = [
        [Item()],
        [Item()],
        [Item()]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
        
        self.items[0].removeAll()
        self.items[1].removeAll()
        self.items[2].removeAll()
        
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
            
            if item.tipo == "Entrada" {
                self.items[0].append(item)
            } else if item.tipo == "Fondo" {
                self.items[1].append(item)
            } else {
                self.items[2].append(item)
            }
            self.tblMenu.reloadData()
            //self.imagenPerfil.sd_setImage(with: URL(string: usuario.fotoURL), completed: nil)
        })
    }
    
    @IBAction func btnConfirmarMenu(_ sender: Any) {
        performSegue(withIdentifier: "confirmarMenuSegue", sender: items)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items[indexPath.section][indexPath.row].menu == false{
            items[indexPath.section][indexPath.row].menu = true
        } else {
            items[indexPath.section][indexPath.row].menu = false
        }
        
        tblMenu.reloadData()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return secciones[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let celda = tblMenu.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblMenuCelda
        celda.imagen?.sd_setImage(with: URL(string: items[indexPath.section][indexPath.row].imagenURL), completed: nil)
        celda.imagen.layer.masksToBounds = true
        celda.imagen.layer.cornerRadius = 5
        celda.lblNombre?.text = items[indexPath.section][indexPath.row].nombre
        celda.lblTipo?.text = items[indexPath.section][indexPath.row].tipo
        celda.lblPrecio?.text = items[indexPath.section][indexPath.row].precio
        
        if items[indexPath.section][indexPath.row].menu == false{
            celda.marca.image = UIImage(named:"unchecked")
        } else {
            celda.marca.image = UIImage(named:"checked")
        }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.22, green:0.56, blue:0.32, alpha:1.0)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! VCConfirmarMenu
        siguienteVC.items = sender as! [[Item]]
    }
    
}
