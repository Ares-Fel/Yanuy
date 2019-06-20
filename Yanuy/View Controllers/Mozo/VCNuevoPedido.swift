
import UIKit
import Firebase
import SDWebImage

class tblPedidoCelda:UITableViewCell{
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var btnMenos: UIButton!
    @IBOutlet weak var btnMas: UIButton!
    @IBOutlet weak var contenedor: UIView!
    @IBOutlet weak var contenedor2: UIView!
    @IBOutlet weak var marca: UIButton!
    
    var cont = 1
    var marcado = false
    var item = Item()
    var pedido_id = ""
    
    @IBAction func btnMarca(_ sender: Any) {
        marcado = !marcado

        if marcado{
            agregarItem()
            marca.setImage(UIImage(named:"checked"), for: .normal)
            btnMenos.isHidden = false
            btnMas.isHidden = false
            lblCantidad.isHidden = false
            cont = 1
            lblCantidad.text! = "\(cont)"
            
        } else {
            quitarItem()
            marca.setImage(UIImage(named:"unchecked"), for: .normal)
            btnMenos.isHidden = true
            btnMas.isHidden = true
            lblCantidad.isHidden = true
        }
    }
    
    @IBAction func btnMasTapped(_ sender: Any) {
        cont += 1
        lblCantidad.text! = "\(cont)"
        modificarCatidad(cantidad: cont)
    }
    
    @IBAction func btnMenosTapped(_ sender: Any) {
        if cont > 0 {
            cont -= 1
            
            if cont == 0 {
                quitarItem()
                marca.setImage(UIImage(named:"unchecked"), for: .normal)
                btnMenos.isHidden = true
                btnMas.isHidden = true
                lblCantidad.isHidden = true
                marcado = !marcado
                
            } else {
                lblCantidad.text! = "\(cont)"
                modificarCatidad(cantidad: cont)
            }
        }
    }
    
    func agregarItem(){
        let datos = ["nombre" : item.nombre, "cantidad" : 1, "tipo" : item.tipo, "precio" : item.precio] as [String : Any]
        Database.database().reference().child("pedidos").child(pedido_id).child("contenido").child(item.id).setValue(datos)
        
    }
    
    func quitarItem(){
        let ref = Database.database().reference().child("pedidos").child(pedido_id).child("contenido").child(item.id)
        ref.removeValue()
        /*let ref = Database.database().reference().child("pedidos").child(item.id)
        ref.updateChildValues(["menu" : false])*/
    }
    
    func modificarCatidad(cantidad:Int){
        let ref = Database.database().reference().child("pedidos").child(pedido_id).child("contenido").child(item.id)
        ref.updateChildValues(["cantidad" : cantidad])
    }
}




class VCNuevoPedido: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tblPedido: UITableView!
    
    var secciones = ["Entradas", "Fondos", "Postres"]

    var items = [               //Array para almacenar los items
        [Item()],
        [Item()],
        [Item()]
    ]
    
    var pedido = Pedido()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPedido.dataSource = self
        tblPedido.delegate = self
        
        //Creamos el pedido
        pedido.id = NSUUID().uuidString
        pedido.estado = "Inactivo"

        let datos = ["nroMesa" : pedido.nroMesa,
                     "fecha" : pedido.fecha,
                     "hora" : pedido.hora,
                     "estado": pedido.estado,
                     "total" : pedido.total] as [String : Any]
        Database.database().reference().child("pedidos").child(pedido.id).setValue(datos)
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            
            self.tblPedido.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /*
            let ref = Database.database().reference().child("pedidos").child(self.pedido.id)
            ref.removeValue()
        */
    }
    
    @IBAction func btnConfirmar(_ sender: Any) {
        print("AQUI EL ID DEL PEDIDO: \(pedido.id)")
        performSegue(withIdentifier: "confirmarPedidoSegue", sender: pedido)
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
        let celda = tblPedido.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! tblPedidoCelda
        
        celda.imagen?.sd_setImage(with: URL(string: item.imagenURL), completed: nil)
        celda.imagen.layer.masksToBounds = true
        celda.imagen.layer.cornerRadius = 5
        celda.lblNombre?.text = item.nombre
        celda.lblPrecio?.text = item.precio
        celda.contenedor.layer.masksToBounds = true
        celda.contenedor.layer.cornerRadius = 5
        celda.contenedor2.layer.masksToBounds = true
        celda.contenedor2.layer.cornerRadius = 5
        
        celda.item = item //Asignamos a cada celda el modelo que deben manejar
        celda.pedido_id = self.pedido.id //Asignamos a cada celda el ID del pedido
        
        switch item.tipo {
        case "Entrada":
            celda.lblNombre?.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.15, alpha:1.0)
        case "Fondo":
            celda.lblNombre?.backgroundColor = UIColor(red:1.00, green:0.65, blue:0.01, alpha:1.0)
        default:
            celda.lblNombre?.backgroundColor = UIColor(red:0.91, green:0.25, blue:0.09, alpha:1.0)
        }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            view.tintColor = UIColor(red:0.00, green:0.60, blue:0.15, alpha:1.0)
        case 1:
            view.tintColor = UIColor(red:1.00, green:0.65, blue:0.01, alpha:1.0)
        default:
            view.tintColor = UIColor(red:0.91, green:0.25, blue:0.09, alpha:1.0)
        }
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func cargarItems(){
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
            
            if item.menu == true{
                //Según el tipo, agregamos cada item a la posición correspondiente del array
                if item.tipo == "Entrada" {
                    self.items[0].append(item)
                } else if item.tipo == "Fondo" {
                    self.items[1].append(item)
                } else {
                    self.items[2].append(item)
                }
            }
            
            self.tblPedido.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmarPedidoSegue"{
            let siguienteVC = segue.destination as! VCConfirmarPedido
            siguienteVC.pedido = sender as! Pedido
        }
        
    }
    
    func cargarPedido(){
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
            
            if item.menu == true{
                //Según el tipo, agregamos cada item a la posición correspondiente del array
                if item.tipo == "Entrada" {
                    self.items[0].append(item)
                } else if item.tipo == "Fondo" {
                    self.items[1].append(item)
                } else {
                    self.items[2].append(item)
                }
            }
            
            self.tblPedido.reloadData()
        })
    }

}
