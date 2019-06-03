
import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class VCNuevoPedido: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblCategorias: UITableView!
    
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCategorias.dataSource = self
        tblCategorias.delegate = self
        
        tableViewData = [cellData(opened: false, title: "Entradas", sectionData: ["Causa", "Caldo Blanco", "Caldo de Gallina"]),
                         cellData(opened: false, title: "Fondos", sectionData: ["Ají de Gallina", "Lomo Saltado", "Rocoto Relleno"]),
                         cellData(opened: false, title: "Postres", sectionData: ["Pie de Manzana", "Pastel de Chocolate", "Gelatina"])]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tblCategorias.dequeueReusableCell(withIdentifier: "categoria") else  { return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
            
        } else {
            guard let cell = tblCategorias.dequeueReusableCell(withIdentifier: "categoria") else  { return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1 ]
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tblCategorias.reloadSections(sections, with: .bottom)
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tblCategorias.reloadSections(sections, with: .none)
        }
    }

}
