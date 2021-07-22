//
//  MyAnnotation.swift
//  TravelSites
//
//  Created by eyal avisar on 22/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import MapKit

class MyAnnotationView: MKAnnotationView {
    private var view: UIView!
    var isBlue: Bool = false {
        didSet {
            if isBlue {
                self.frame = CGRect(x: 0, y: 25, width: 50, height: 50)
                view.frame = frame
                view.backgroundColor = .blue
                view.alpha = 0.5
                view.layer.cornerRadius = view.bounds.width / 2
                
                let myView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                myView.center = view.center
                myView.backgroundColor = .blue
                myView.layer.cornerRadius = myView.bounds.width / 2
                self.addSubview(myView)
                
                let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                innerView.center = view.center
                innerView.backgroundColor = .white
                innerView.layer.cornerRadius = innerView.bounds.width / 2
                self.addSubview(innerView)
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.view = UIView(frame: frame)
        view.backgroundColor = .green
        self.addSubview(self.view)
        view.layer.cornerRadius = view.bounds.width / 2
        self.view.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
