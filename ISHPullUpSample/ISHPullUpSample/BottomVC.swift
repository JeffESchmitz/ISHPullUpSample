//
//  BottomVC.swift
//  ISHPullUpSample
//
//  Created by Jeff Schmitz on 10/3/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
//import ISHPullUp
import UIKit
import MapKit

class BottomVC: UIViewController
    ,ISHPullUpSizingDelegate
    ,ISHPullUpStateDelegate
{
    @IBOutlet weak var handleView: ISHPullUpHandleView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttonLock: UIButton!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    
    // we allow the pullUp to snap to the half-way point
    private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true
    }
    
    private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        if pullUpController.isLocked {
            return
        }
        pullUpController.toggleState(animated: true)
    }
 
    @IBAction func buttonTappedLearnMore(_ sender: AnyObject) {
        // for demo purposes, we replace the bottomViewController with a web view controller
        // there is no way back in the sample app though
        // this also highlights the behavior of the pullup view controller without a sizing and state delegate
//        let webVC = WebViewController()
//        webVC.loadURL(URL(string: "https://iosphere.de"))
//        pullUpController.bottomViewController = webVC
    }
    
    @IBAction func buttonTappedLock(_ sender: AnyObject) {
        pullUpController.isLocked = !pullUpController.isLocked
        buttonLock?.setTitle(pullUpController.isLocked ? "Unlock" : "Lock", for: .normal)
    }
    
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        // we allow the pullUp to snap to the half way point
        // we "calculate" the cached value here
        // and perform the snapping in ..targetHeightForBottomViewController..
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        // if around 30pt of the half way point -> snap to it
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        
        // default behavior
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController contentVC: UIViewController) {
        // we update the scroll view's content inset
        // to properly support scrolling in the intermediate states
        scrollView.contentInset = edgeInsets
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        topLabel.text = textForState(state)
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
    }
    
    private func textForState(_ state: ISHPullUpState) -> String {
        switch state {
        case .collapsed:
            return "Drage up or tap"
        case .intermediate:
            return "Intermediate"
        case .dragging:
            return "Hold on"
        case .expanded:
            return "Drag down or tap"
        }
    }
}

class ModalViewController: UIViewController {
    
    @IBAction func buttonTappedDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}



