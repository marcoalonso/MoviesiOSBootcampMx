//
//  HomeViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit
import FirebaseAuth
import Kingfisher

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
        
        obtenerPeliculas()
        
        setupCollection()
    }
    
    private func setupCollection(){
        moviesCollection.collectionViewLayout = UICollectionViewFlowLayout()
        if let flowLayout = moviesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func obtenerPeliculas(){
        manager.getPopularMovies { listadoPeliculas in
            self.peliculas = listadoPeliculas
            
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
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
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! MovieCell
        
        if let url = URL(string: "\(Constants.urlImages)\(peliculas[indexPath.row].poster_path ?? "")") {
            celda.posterMovie.kf.setImage(with: url)
        }
        
        celda.titleMovie.text = peliculas[indexPath.row].title
        celda.dateMovie.text = peliculas[indexPath.row].release_date
        celda.overviewMovie.text = peliculas[indexPath.row].overview
        
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 195, height: 320)
    }
    
}
