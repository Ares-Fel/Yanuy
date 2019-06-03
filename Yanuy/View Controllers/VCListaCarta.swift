
import UIKit

class tblCartaCelda: UITableViewCell {
    
    @IBOutlet weak var imagenCarta: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    
}

class VCListaCarta: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblCarta: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCarta.delegate = self
        tblCarta.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tblCarta.dequeueReusableCell(withIdentifier: "item", for:
            indexPath) as! tblCartaCelda
        celda.lblNombre?.text = "Ají de Gallina"
        celda.lblTipo?.text = "Tipo: Fondo"
        celda.lblPrecio?.text = "Precio: S/ 12.00"
        celda.lblStock?.text = ""
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verCartaSegue", sender: nil)
    }
    

}
