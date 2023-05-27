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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.delegate = self
        
        ///Reproducir el video
        playerView.load(withVideoId: "lnofrnqmi2o")
        
    }
    
    ///
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    

}
