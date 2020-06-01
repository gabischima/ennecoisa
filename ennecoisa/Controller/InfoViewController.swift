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
    
    var delegate: SetToolsPositionDelegate?
    
    struct Section {
        var title: String
        var items: [Subsection]
    }

    struct Subsection {
        var title: String
        var cellIdentifier: String?
        var image: UIImage?
    }
    
    let sections: [Section] = [
        Section(title: "Configurations", items: [
            Subsection(title: "Drawing tools position", cellIdentifier: "switchCell", image: nil),
            Subsection(title: "Save drawing", cellIdentifier: "cell", image: nil)
        ]),
        Section(title: "Info", items: [
            Subsection(title: "Download blank enne", cellIdentifier: "cell", image: UIImage(named: "download")),
            Subsection(title: "Go to website", cellIdentifier: "cell", image: UIImage(named: "external_link"))
        ])
    ]
    
    var toolsPosition: ToolsPosition = .right

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
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
    
    @objc func changeInterface(sender: UISegmentedControl) {
        if (self.delegate) != nil {
            delegate?.setToolsPosition(position: ToolsPosition(rawValue: sender.selectedSegmentIndex) ?? .right)
        }
        
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
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
        if (sections[indexPath.section].items[indexPath.row].cellIdentifier == "switchCell") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            cell.title?.text = sections[indexPath.section].items[indexPath.row].title
            cell.imageView?.image = sections[indexPath.section].items[indexPath.row].image ?? nil
            cell.interfaceSwitch.selectedSegmentIndex = toolsPosition.rawValue
            cell.interfaceSwitch.addTarget(self, action: #selector(changeInterface(sender:)), for: .valueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultTableViewCell
            cell.title?.text = sections[indexPath.section].items[indexPath.row].title
            cell.imageView?.image = sections[indexPath.section].items[indexPath.row].image ?? nil
            return cell
        }
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
