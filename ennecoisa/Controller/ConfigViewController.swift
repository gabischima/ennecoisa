//
//  ConfigViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 25/02/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ConfigurationDelegate?
    
    struct Section {
        var items: [Item]
    }

    struct Item {
        var title: String
        var cellIdentifier: CellIdentifier
        var image: UIImage?
    }
    
    enum CellIdentifier: String {
        case `default` = "cell"
        case switchCell = "switchCell"
        case detail = "detail"
    }
    
    var selectedCell: DefaultTableViewCell?
    
    let sections: [Section] = [
        Section(items: [
            Item(title: "Save drawing", cellIdentifier: .default, image: UIImage(named: "download")),
            Item(title: "Drawing tools position", cellIdentifier: .switchCell, image: UIImage(named: "drawing_tools")),
            Item(title: "Clear drawing", cellIdentifier: .default, image: UIImage(named: "trash"))
        ]),
        Section(items: [
            Item(title: "Download blank Enne", cellIdentifier: .default, image: UIImage(named: "download")),
            Item(title: "Go to website", cellIdentifier: .default, image: UIImage(named: "external_link")),
            Item(title: "Instagram Ennecoisa", cellIdentifier: .default, image: UIImage(named: "instagram"))
        ]),
        Section(items: [
            Item(title: "App version", cellIdentifier: .detail, image: UIImage(named: "tag"))
        ])
    ]
    
    var toolsPosition: ToolsPosition = .right

    var appVersion: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
}

//MARK: - ViewController functions
extension ConfigViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detail")
    }
}

//MARK: - Image save Callback
extension ConfigViewController {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            // Error saving image
            showAlert(title: "Image could not be saved", message: "Please, check permissions.", type: .default)
            selectedCell?.status = .default
            selectedCell = nil
            return
        }
        selectedCell?.status = .success
        selectedCell = nil
    }
}

//MARK: - Alerts
extension ConfigViewController {
    func showAlert(title: String, message: String, type: UIAlertAction.Style) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: type, handler: nil))
        self.present(alert, animated: true)
    }
    
    func confirmationAlert(title: String, message: String, origin: IndexPath) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            self.selectedCell?.status = .default
            self.selectedCell = nil
        }))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            guard let del = self.delegate else { return }
            del.clearCanvas()
            self.selectedCell?.status = .success
            self.selectedCell = nil
        }))
        self.present(alert, animated: true)
    }
}

//MARK: - Open URL
extension ConfigViewController {
    func openSite() {
        UIApplication.shared.open(URL(string: "https://gabischima.github.io/en/ennecoisa")!, options: [:], completionHandler: nil)
    }
    
    func openInstagram() {
        let instagramHook = URL(string: "instagram://user?username=ennecoisa")
        if UIApplication.shared.canOpenURL(instagramHook! as URL) {
            UIApplication.shared.open(instagramHook!)
        } else {
            UIApplication.shared.open(URL(string: "http://instagram.com/ennecoisa")!)
        }
    }
}
//MARK: - Cell actions
extension ConfigViewController {
    @objc func changeInterface(sender: UISegmentedControl) {
        if (self.delegate) != nil {
            delegate?.setToolsPosition(position: ToolsPosition(rawValue: sender.selectedSegmentIndex) ?? .right)
        }
    }
    
    func saveDrawing() {
        guard let image = delegate?.saveEnneToCameraRoll() else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func saveBlankEnne() {
        guard let image = UIImage(named: "card") else { return }
        let contextSize = CGSize(width: image.size.width, height: image.size.height)

        UIGraphicsBeginImageContext(contextSize)
        let contextRect = CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height)

        image.draw(in: contextRect)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        UIImageWriteToSavedPhotosAlbum(newImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

//TODO: Separate delegate / datasource
extension ConfigViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item.cellIdentifier {
            case .default:
                let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier.rawValue, for: indexPath) as! DefaultTableViewCell
                cell.title?.text = NSLocalizedString(item.title, comment: "")
                cell.icon?.image = item.image ?? nil
                return cell
            case .switchCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier.rawValue, for: indexPath) as! SwitchTableViewCell
                cell.title?.text = NSLocalizedString(item.title, comment: "")
                cell.icon?.image = item.image ?? nil
                cell.interfaceSwitch.selectedSegmentIndex = toolsPosition.rawValue
                cell.interfaceSwitch.addTarget(self, action: #selector(changeInterface(sender:)), for: .valueChanged)
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case .detail:
                let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier.rawValue, for: indexPath) as! DetailTableViewCell
                cell.title?.text = NSLocalizedString(item.title, comment: "")
                cell.icon?.image = item.image ?? nil
                cell.detail?.text = appVersion
                return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.cellForRow(at: indexPath) as! DefaultTableViewCell
                    cell.status = .loading
                    self.selectedCell = cell
                    DispatchQueue.main.async {
                        self.saveDrawing()
                    }
                case 1:
                    break
                case 2:
                    let cell = tableView.cellForRow(at: indexPath) as! DefaultTableViewCell
                    selectedCell = cell
                    cell.status = .loading
                    confirmationAlert(title: "Clear drawing", message: "Are you sure you want to delete your drawing? This action cannot be undone.", origin: indexPath)
                    break
                default:
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    let cell = tableView.cellForRow(at: indexPath) as! DefaultTableViewCell
                    selectedCell = cell
                    cell.status = .loading
                    /*
                     simple save image stoped working
                     had to add context
                    */
                    DispatchQueue.main.async {
                        self.saveBlankEnne()
                    }
                case 1:
                    openSite()
                case 2:
                    openInstagram()
                default:
                    break
                }
            default:
                break
        }
    }
}
