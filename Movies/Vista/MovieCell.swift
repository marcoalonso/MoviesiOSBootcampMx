//
//  MovieCell.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleMovie: UILabel!
    
    @IBOutlet weak var overviewMovie: UITextView!
    @IBOutlet weak var dateMovie: UILabel!
    @IBOutlet weak var posterMovie: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
