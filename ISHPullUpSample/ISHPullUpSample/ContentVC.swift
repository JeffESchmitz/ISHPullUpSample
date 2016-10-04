//
//  ContentVC.swift
//  ISHPullUpSample
//
//  Created by Jeff Schmitz on 10/3/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ISHPullUp

class ContentVC: UIViewController, ISHPullUpContentDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var layoutAnnotationLabel: UILabel!
    // rootView rely's on edge's inset, which cannot be set in VC's view directly
    @IBOutlet weak var rootView: UIView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutAnnotationLabel.layer.cornerRadius = 2
        
        // the mapView should use the rootView's layout margins
        // to correctly update the legal label and coordinate region
        mapView.preservesSuperviewLayoutMargins = true
    }
    
    // MAR: ISHPullUpContentDelegate
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController contentVC: UIViewController) {
        
        // update edgeInsets
        rootView.layoutMargins = edgeInsets
        
        // call layouIfNeeded right away to participate in aninmations.
        // this method may be called from within animageion blocks
        rootView.layoutIfNeeded()
    }
}
