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
    
    func updateSelectedStatus(status: Bool) {
        // if status is true, set a purple border
        if status {
            contentView.layer.cornerRadius = 5.0
            contentView.layer.borderWidth = 2.0
            // the contentView only takes in normalized colors, that's why we have to divide
            contentView.layer.borderColor = UIColor(red: 149.0 / 255.0, green: 67.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
            // else, no border
        } else {
            // hides the border
            contentView.layer.borderWidth = 0.0
        }
        
       
       
    }
    
    
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
