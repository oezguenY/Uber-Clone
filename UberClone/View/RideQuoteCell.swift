//
//  RideQuoteCell.swift
//  UberClone
//
//  Created by Özgün Yildiz on 28.04.21.
//

import UIKit

class RideQuoteCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var capacityLabel: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func update(rideQuote: RideQuote) {
        thumbnailImageView.image = UIImage(named: rideQuote.thumbnail)
        titleLabel.text = rideQuote.name
        capacityLabel.image = UIImage(named: rideQuote.capacity)
        priceLabel.text = String(format: "$%.2f", rideQuote.price)
       
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mma"
        
        timeLabel.text = dateFormatter.string(from: rideQuote.time)
    }
}
