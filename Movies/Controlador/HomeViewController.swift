//
//  HomeViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var moviesCollection: UICollectionView!
    
    var peliculas: [DataMovie] = []
    
    let manager = MoviesManager()
    
    ///Una instancia de bd userdefaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "celda")
        
        moviesCollection.delegate = self
        moviesCollection.dataSource = self
        
        defaults.set("logueado", forKey: "sesionIniciada")
        
        manager.getPopularMovies { listadoPeliculas in
            print("num pelis: \(listadoPeliculas.count)")
        }
    }
    
    func navegarLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
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
}

// MARK:  CollectionView
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! MovieCell
        
        celda.posterMovie.image = UIImage(systemName: "note")
        celda.titleMovie.text = "Mario Bros"
        celda.dateMovie.text = "Mayo 2023"
        celda.overviewMovie.text = "Descripcion pelicula"
        
        return celda
    }
    
    
}
