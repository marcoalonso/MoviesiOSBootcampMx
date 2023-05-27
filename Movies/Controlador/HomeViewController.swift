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
    
    var peliculas : [DataMovie] = []
    var popularMovies : [DataMovie] = []
    var upcominMovies : [DataMovie] = []
    
    var peliculaSeleccionada: DataMovie?
    
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
            self.popularMovies = listadoPeliculas
            self.peliculas = listadoPeliculas
            
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
        }
        
        manager.getUpcominMovies { listadoPeliculas in
            print("getUpcominMovies: \(listadoPeliculas.count)")
            self.upcominMovies = listadoPeliculas
        }
    }
    
    func navegarLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @IBAction func tipoPeliculasSegmented(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.peliculas.removeAll()
            self.peliculas = popularMovies
            
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
            
        case 1:
            print("estrenos")
            self.peliculas.removeAll()
            self.peliculas = upcominMovies
            
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
            
        case 2:
            print("topRated")
        default:
            print("default")
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        peliculaSeleccionada = peliculas[indexPath.row]
        
        performSegue(withIdentifier: "detalleMovie", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleMovie" {
            //Crear una instancia de la segunda pantalla para acceder a sus atributos
            let objDetalleMovie = segue.destination as! DetalleMovieViewController
            objDetalleMovie.recibirMovieMostrar = peliculaSeleccionada
        }
    }
    
    
}
