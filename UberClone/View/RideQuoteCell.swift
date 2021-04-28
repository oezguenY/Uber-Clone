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
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func update(rideQuote: RideQuote) {
        thumbnailImageView.image = UIImage(named: rideQuote.thumbnail)
        titleLabel.text = rideQuote.name
        capacityLabel.text = rideQuote.capacity
        // formatting the price, which is a Double, to a string with 2 digits
        priceLabel.text = String(format: "$%.2f", rideQuote.price)
       
        // for the purpose of converting the date of the rideQuote to a string, we have to use a dateformatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        
        timeLabel.text = dateFormatter.string(from: rideQuote.time)
    }
}
