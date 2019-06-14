
import UIKit
import Firebase
import SDWebImage

class tblCartaCelda: UITableViewCell {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
}

class VCListaItems: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tblCarta: UITableView!
    
    var items = [               //Array para almacenar TODOS los items
        [Item()],
        [Item()],
        [Item()]
    ]
    
    var itemsFiltrados = [      //Array para almacenar solo los resultados de nuestra búsqueda
        [Item()],
        [Item()],
        [Item()]
    ]

    var secciones = ["Entradas", "Fondos", "Postres"]
    
    var textoBusqueda = "" //Texto de Búsqueda
    var searchController:UISearchController! //Barra de Búsqueda

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblCarta.delegate = self
        tblCarta.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        tblCarta.tableHeaderView = searchController.searchBar //Agregamos la barra en la cabecera

        //Barra de búsqueda
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar..."
        searchController.searchBar.tintColor = UIColor.gray
        searchController.searchBar.barTintColor = UIColor(red:1.00, green:0.56, blue:0.32, alpha:1.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Se recargará la tabla")
        cargarItems()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Text \(searchController.searchBar.text!)")
        self.textoBusqueda = searchController.searchBar.text!
        
        itemsFiltrados[0].removeAll()   //Reiniciamos el Array de resultados de búsqueda
        itemsFiltrados[1].removeAll()
        itemsFiltrados[2].removeAll()
        
        for i in items {
            for j in i {
                if j.nombre.lowercased().contains(textoBusqueda.lowercased()) { //Comparamos el texto ingresado en la barra de búsqueda con cada elemento del Array
                    switch j.tipo {
                    case "Entrada": itemsFiltrados[0].append(j)
                    case "Fondo": itemsFiltrados[1].append(j)
                    default: itemsFiltrados[2].append(j)
                    }
                }
            }
        }
        
        tblCarta.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return secciones[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.textoBusqueda != "" {  //Si hay una búsqueda en proceso, se contará el número de ELEMENTOS FILTRADOS en el Array correspondiente
            return itemsFiltrados[section].count
        } else {  //Si no hay una búsqueda en proceso, se contarán TODOS los elementos obtenidos de la consulta
            return items[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item = items[indexPath.section][indexPath.row]
        
        if self.textoBusqueda != "" { //Si hay una búsqueda en proceso, el item se obtiene de la lista de elementos filtrados
            item = itemsFiltrados[indexPath.section][indexPath.row]
            
        }
        
        let celda = tblCarta.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblCartaCelda
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
        var item = items[indexPath.section][indexPath.row] //Obtenemos la celda seleccionada
        
        if textoBusqueda != "" { //Si hay una búsqueda en proceso, el item se obtiene de la lista de elementos filtrados
            item = itemsFiltrados[indexPath.section][indexPath.row]
        }
        
        searchController.isActive = false
        performSegue(withIdentifier: "verItemSegue", sender: item)
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
