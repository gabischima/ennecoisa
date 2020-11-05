//
//  DefaultTableViewCell.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 30/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak private var loadingView: UIImageView!
    @IBOutlet weak private var checkView: UIImageView!
    
    let loadingAnimation: [UIImage]? = [
        UIImage(named: "loading-1")!,
        UIImage(named: "loading-2")!,
        UIImage(named: "loading-3")!,
        UIImage(named: "loading-4")!,
        UIImage(named: "loading-5")!,
        UIImage(named: "loading-6")!,
        UIImage(named: "loading-7")!,
        UIImage(named: "loading-8")!
    ]
    
    let checkAnimation: [UIImage]? = [
        UIImage(named: "check_animation-1")!,
        UIImage(named: "check_animation-2")!,
        UIImage(named: "check_animation-3")!,
        UIImage(named: "check_animation-4")!,
        UIImage(named: "check_animation-5")!,
        UIImage(named: "check_animation-6")!,
        UIImage(named: "check_animation-7")!,
        UIImage(named: "check_animation-8")!,
        UIImage(named: "check_animation-6")!,
        UIImage(named: "check_animation-7")!,
        UIImage(named: "check_animation-8")!
    ]
    
    var status: Status = .default {
        didSet {
            switch status {
            case .default:
                loadingView?.isHidden = true
                checkView?.isHidden = true
                break
            case .error:
                break
            case .loading:
                loadingView?.isHidden = false
                loadingView?.startAnimating()
            case .success:
                checkView?.isHidden = false
                loadingView?.isHidden = true
                checkView?.startAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
                    self.status = .default
                }
            }
        }
    }
    
    enum Status {
        case loading, success, error, `default`
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        selectionStyle = .none
        loadingView?.isHidden = true
        loadingView?.animationImages = loadingAnimation
        loadingView?.animationRepeatCount = 0
        loadingView?.animationDuration = 0.8
        
        checkView?.isHidden = true
        checkView?.animationImages = checkAnimation
        checkView?.animationRepeatCount = 1
        checkView?.animationDuration = 0.8
    }
}
