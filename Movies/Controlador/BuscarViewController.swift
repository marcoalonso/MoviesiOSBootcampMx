//
//  BuscarViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 27/05/23.
//

import UIKit
import Kingfisher

class BuscarViewController: UIViewController {
    
    
    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var nombreMovie: UITextField!
    
    var manager = MoviesManager()
    
    var peliculasEncontradas: [DataMovie] = [] //llenar mi collection
    var peliculaSeleccioanda: DataMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nombreMovie.delegate = self
        
        moviesCollection.dataSource = self
        moviesCollection.delegate = self
        
        moviesCollection.register(UINib(nibName: "MovieEncontradaCell", bundle: nil), forCellWithReuseIdentifier: "celda")
        
        moviesCollection.collectionViewLayout = UICollectionViewFlowLayout()
        if let flowLayout = moviesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        

    }
    
    func buscarPeliculas(nombre: String){
        manager.searchMovies(nameOfMovie: nombre) { listaPeliculasEncontradas in
            print("listaPeliculasEncontradas : \(listaPeliculasEncontradas)")
            
            self.peliculasEncontradas = listaPeliculasEncontradas
            
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
            
        }
    }
    
}

extension BuscarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
  
}

extension BuscarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peliculasEncontradas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! MovieEncontradaCell
        
        celda.posterMovie.image = UIImage(systemName: "car")
        
        if let url = URL(string: "\(Constants.urlImages)\(peliculasEncontradas[indexPath.row].poster_path ?? "")") {
            celda.posterMovie.kf.setImage(with: url)
            celda.posterMovie.layer.cornerRadius = 15
            celda.posterMovie.layer.masksToBounds = true
        }
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Vibracion
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        peliculaSeleccioanda = peliculasEncontradas[indexPath.row]
        
        performSegue(withIdentifier: "trailer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailer" {
            let trailerVC = segue.destination as! DetalleMovieViewController
            trailerVC.recibirMovieMostrar = peliculaSeleccioanda
        }
    }
    
    
}

extension BuscarViewController: UITextFieldDelegate {
    //1.- Habilitar el boton del teclado virtual
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hacer algo")
        textField.endEditing(true)
        return true
    }
    
    //2.- Identificar cuando el usuario termina de editar y que pueda borrar el contenido del textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.count > 3 {
            let nombreMovie = textField.text!.replacingOccurrences(of: " ", with: "%20").folding( options: .diacriticInsensitive,locale: .current)
            buscarPeliculas(nombre: nombreMovie)
        }
        
        textField.text = ""
        textField.endEditing(true)
    }
    
    //3.- Evitar que el usuario no escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            mostrarAlerta(titulo: "Atención", mensaje: "Para buscar una película, debes escribir el nombre de ésta.")
            return false
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
}

