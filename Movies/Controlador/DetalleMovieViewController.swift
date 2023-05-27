//
//  DetalleMovieViewController.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 27/05/23.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetalleMovieViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var manager = MoviesManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.delegate = self
        
        manager.getTrailersMovie(id: 502356) { listadoTrailers in
            print("listadoTrailers \(listadoTrailers.count)" )
        }
        
        ///Reproducir el video lnofrnqmi2o
        ///
        playerView.load(withVideoId: "8rHNp7cPUb0")
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    

}
