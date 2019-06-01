
import UIKit

class VCNuevoPedido: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblCategorias: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCategorias.dataSource = self
        tblCategorias.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tblCategorias.dequeueReusableCell(withIdentifier: "categorias", for: indexPath)
        return celda;
    }

}
