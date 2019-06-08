
import UIKit

class VCConfirmarMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblConfirmar: UITableView!
    
    var items = [
        [Item(),Item(),Item()],
        [Item()],
        [Item()]
    ]
    
    override func viewDidLoad() {
        
        tblConfirmar.delegate = self
        tblConfirmar.dataSource = self
        super.viewDidLoad()
        
        for i in items{
            for j in i{
                print(j.nombre)
            }
        }
        
        print(items[1][1].nombre)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
