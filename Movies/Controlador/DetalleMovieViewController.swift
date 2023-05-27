//
//  DetalleMovieViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 27/05/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetalleMovieViewController: UIViewController, YTPlayerViewDelegate {
    
    var recibirMovieMostrar: DataMovie?
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var nombreMovie: UILabel!
    @IBOutlet weak var fechaMovie: UILabel!
    @IBOutlet weak var descripcionMovie: UILabel!
    
    
    var manager = MoviesManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarUI()

        playerView.delegate = self
        
    }
    
    func configurarUI(){
        nombreMovie.text = recibirMovieMostrar?.title
        fechaMovie.text = "fecha estreno: \(recibirMovieMostrar?.release_date ?? "")"
        descripcionMovie.text = recibirMovieMostrar?.overview
        
        obtenerTrailers(id: recibirMovieMostrar?.id ?? 0)
    }
    
    func obtenerTrailers(id: Int){
        manager.getTrailersMovie(id: id) { listadoTrailers in
            print("listadoTrailers \(listadoTrailers.count)")
            
            if let trailerReproducir = listadoTrailers.last?.key {
                DispatchQueue.main.async {
                    ///Reproducir el video lnofrnqmi2o
                    self.playerView.load(withVideoId: trailerReproducir)
                }
            }
        }
    }
    
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    

}
