//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Toby Youngberg on 4/18/23.
//

import UIKit

@MainActor
class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet var waitingSpinner: UIActivityIndicatorView!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        
        self.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
        self.copyrightLabel.text = photoInfo.copyright
        Task {
            do {
                let image = try await photoInfoController.fetchImage(from: photoInfo.url)
                self.imageView.image = image
                self.waitingSpinner.isHidden = true
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    func updateUI(with error: Error) {
        self.title = "Error Fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
        self.waitingSpinner.isHidden = true
    }
}

