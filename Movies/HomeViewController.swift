//
//  HomeViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    ///Una instancia de bd userdefaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        //Guardar sesion en BD
        defaults.set("logueado", forKey: "sesionIniciada")
    }
    

    @IBAction func salirButton(_ sender: UIButton) {
        //Borrar la sesion 
        defaults.removeObject(forKey: "sesionIniciada")
        
        //Cerrar sesion en firebase
        do {
            try Auth.auth().signOut()
            navegarLogin()
        } catch {
            print("Debug: error al cerrar sesion \(error.localizedDescription)")
        }
    }
    
    func navegarLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }

}
