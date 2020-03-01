//
//  InfoViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 25/02/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let titles =
    [
        [
            "Download blank enne",
            "Go to website"
        ]
    ]
    
    let images =
    [
        [
            "download",
            "external_link"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // show close btn if iOS < 13.0
        if #available(iOS 13, *) {
            self.closeBtn.isHidden = true
        } else {
            self.closeBtn.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            // Error saving image
            showAlert(title: "Photo could not be saved", message: "Please, check permissions.")
            return
        }
        // Image saved successfully
        showAlert(title: "Success!", message: "Image was successfully saved.")
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    func openSite () {
        UIApplication.shared.open(URL(string: "https://gabischima.github.io/en/ennecoisa")!, options: [:], completionHandler: nil)
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = NSLocalizedString(titles[indexPath.section][indexPath.row], comment: "")
        cell.imageView?.image = UIImage(named: images[indexPath.section][indexPath.row])
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                if let image = UIImage(named: "card") {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            case 1:
                openSite()
            default:
                break
            }
        }
    }
}
