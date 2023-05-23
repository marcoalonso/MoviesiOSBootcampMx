//
//  RegistroViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {
    
    
    @IBOutlet weak var contrasenaTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Oculta el boton back por default
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
            //Do something
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    @IBAction func AceptarButton(_ sender: UIButton) {
        if let email = correoTextField.text, let password = contrasenaTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    //error a crear usuario
                    self.mostrarAlerta(titulo: "ATENCIÓN", mensaje: "Ocurrió un error al registrar el usuario: \(error!.localizedDescription)")
                } else {
                    // Registro exitoso, mandar al usuario al home...
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
            }
        }
    }
    
    

    @IBAction func loginButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
