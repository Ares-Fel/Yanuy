
import UIKit
import Firebase
import SDWebImage

class tblCartaCelda: UITableViewCell {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
}

class VCListaItems: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblCarta: UITableView!
    
    var items = [               //Array para almacenar TODOS los items
        [Item()],
        [Item()],
        [Item()]
    ]

    var secciones = ["Entradas", "Fondos", "Postres"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tblCarta.delegate = self
        tblCarta.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarItems()
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
        let celda = tblCarta.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblCartaCelda
        var item = items[indexPath.section][indexPath.row]

        celda.lblNombre?.text = item.nombre
        celda.lblPrecio?.text = "S/\(item.precio)"
        celda.lblNombre?.layer.masksToBounds = true
        celda.lblNombre?.layer.cornerRadius = 5
        celda.imagenCarta?.sd_setImage(with: URL(string: item.imagenURL), completed: nil)
        celda.imagenCarta.backgroundColor = UIColor.clear
        celda.imagenCarta.layer.masksToBounds = true
        celda.imagenCarta.layer.cornerRadius = 5
        
        switch item.tipo {
            case "Entrada":
                celda.lblNombre?.backgroundColor = UIColor(red:0.22, green:0.56, blue:0.32, alpha:1.0)
            case "Fondo":
                celda.lblNombre?.backgroundColor = UIColor(red:0.83, green:0.82, blue:0.04, alpha:1.0)
            default:
                celda.lblNombre?.backgroundColor = UIColor(red:0.96, green:0.38, blue:0.60, alpha:1.0)
        }
        
        return celda
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verItemSegue", sender:items[indexPath.section][indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            view.tintColor = UIColor(red:0.22, green:0.56, blue:0.32, alpha:1.0)
        case 1:
            view.tintColor = UIColor(red:0.83, green:0.82, blue:0.04, alpha:1.0)
        default:
            view.tintColor = UIColor(red:0.96, green:0.38, blue:0.60, alpha:1.0)
        }
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verItemSegue" {
            let siguienteVC = segue.destination as! VCVerItem
            siguienteVC.item = sender as! Item
            
        }
    }
    
    func cargarItems() {
        self.items[0].removeAll()  //Reiniciamos el Array
        self.items[1].removeAll()
        self.items[2].removeAll()
        Database.database().reference().child("items").observe(DataEventType.childAdded, with: { (snapshot) in
            print("AQUI: \(snapshot)")
            
            let item = Item()
            item.nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            item.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            item.precio = (snapshot.value as! NSDictionary)["precio"] as! String
            item.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            item.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            item.menu = (snapshot.value as! NSDictionary)["menu"] as! Bool
            item.id = snapshot.key
            
            //Según el tipo, agregamos cada item a la posición correspondiente del array
            if item.tipo == "Entrada" {
                self.items[0].append(item)
            } else if item.tipo == "Fondo" {
                self.items[1].append(item)
            } else {
                self.items[2].append(item)
            }
            self.tblCarta.reloadData()
        })
    }

}
