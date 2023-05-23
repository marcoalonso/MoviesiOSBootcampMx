//
//  ViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var contrasena: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //El usuario ya inicio sesion
        if defaults.string(forKey: "sesionIniciada") != nil {
            //Navegal al home
            self.performSegue(withIdentifier: "loginGoToHome", sender: self)
        }
    }
    
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
            //Do something
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        if let email = correo.text, let password = contrasena.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    
                    if error!.localizedDescription == "The email address is badly formatted." {
                        self.mostrarAlerta(titulo: "ATENCIÓN", mensaje: "El correo esta en un formato incorrecto.")
                    }
                    
                    if error!.localizedDescription == "The password is invalid or the user does not have a password." {
                        self.mostrarAlerta(titulo: "ATENCIÓN", mensaje: "La contraseña que escribiste no corresponde con el correo.")
                    }
                    
                    if error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.mostrarAlerta(titulo: "ATENCIÓN", mensaje: "Correo no registrado o cuenta eliminada.")
                    }
                    
                } else {
                    self.performSegue(withIdentifier: "loginGoToHome", sender: self)
                }
            }
        }
    }
    
    
}

