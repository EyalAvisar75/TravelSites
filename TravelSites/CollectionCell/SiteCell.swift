//
//  SiteCell.swift
//  TravelSites
//
//  Created by eyal avisar on 13/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import UIKit

class SiteCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let siteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var curtain: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.5)
        return view
    }()
    
    var checkmarkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height * 0.8)
        
        contentView.addSubview(curtain)
        curtain.frame = .zero
        
        contentView.addSubview(siteLabel)
        siteLabel.frame = CGRect(x: 0, y: contentView.bounds.height * 0.8, width: contentView.bounds.width, height: contentView.bounds.height * 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleCurtain(isChecked: Bool) {
        if isChecked {
            curtain.frame = .zero
            checkmarkImageView.removeFromSuperview()
        }
        else {
            curtain.removeFromSuperview()
            curtain.frame = contentView.frame
            contentView.addSubview(curtain)
            checkmarkImageView = UIImageView(frame: CGRect(x: curtain.bounds.width - 20, y: 0, width: 20, height: 20))
            checkmarkImageView.image = UIImage(systemName: "checkmark")
            curtain.addSubview(checkmarkImageView)
        }
    }
}
