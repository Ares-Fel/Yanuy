
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

class VCListaMenu: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tblMenu: UITableView!
    var secciones = ["Entradas", "Fondos", "Postres"]
    
    var textoBusqueda = NSString() //Texto de Búsqueda
    var searchController:UISearchController! //Barra de Búsqueda
    
    var items = [
        [Item()],
        [Item()],
        [Item()]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        tblMenu.tableHeaderView = searchController.searchBar //Agregamos la barra en la cabecera
        
        //barra de búsqueda
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar..."
        searchController.searchBar.tintColor = UIColor.gray
        searchController.searchBar.barTintColor = UIColor(red:1.00, green:0.56, blue:0.32, alpha:1.0)
        
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
        })
    }
    
    @IBAction func btnConfirmarMenu(_ sender: Any) {
        performSegue(withIdentifier: "confirmarMenuSegue", sender: items)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Text \(searchController.searchBar.text!)")
        self.textoBusqueda = searchController.searchBar.text! as NSString
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.section][indexPath.row]

        if item.menu == false{
            item.menu = true
            let ref = Database.database().reference().child("items").child(item.id)
            ref.updateChildValues(["menu" : true])
        } else {
            item.menu = false
            let ref = Database.database().reference().child("items").child(item.id)
            ref.updateChildValues(["menu" : false])
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
        
        let item = items[indexPath.section][indexPath.row]

        let celda = tblMenu.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblMenuCelda
        celda.imagen?.sd_setImage(with: URL(string: item.imagenURL), completed: nil)
        celda.imagen.layer.masksToBounds = true
        celda.imagen.layer.cornerRadius = 5
        celda.lblNombre?.text = item.nombre
        celda.lblTipo?.text = item.tipo
        celda.lblPrecio?.text = item.precio
        
        if item.menu == false{
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
