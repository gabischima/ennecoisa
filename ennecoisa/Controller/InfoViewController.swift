//
//  InfoViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 25/02/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Section {
        var title: String?
        var items: [Subsection]?
        
        struct Subsection {
            var title: String?
            var image: UIImage?
        }
    }
    
    let sections: [Section] = [
        Section(title: "Configurations", items: [
            Section.Subsection(title: "Right hand interface", image: nil),
            Section.Subsection(title: "Save drawing", image: nil)
        ]),
        Section(title: "Info", items: [
            Section.Subsection(title: "Download blank enne", image: UIImage(named: "download")),
            Section.Subsection(title: "Go to website", image: UIImage(named: "external_link"))
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = NSLocalizedString(sections[indexPath.section].items?[indexPath.row].title ?? "", comment: "")
        cell.imageView?.image = sections[indexPath.section].items?[indexPath.row].image
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            print("section 1")
        case 1:
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
        default:
            break
        }
    }
}
