//
//  LibraryTableViewCell.swift
//  Spotify
//
//  Created by Admin on 09/12/24.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var dotLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
