import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!

    @IBAction func downloadPressed(_ sender: Any) {

        Downloader.shared.progressHandler = { progress in
            self.progressBar.progress = progress
        }

        Downloader.shared.completion = { fileURL in
            print("Downloaded:", fileURL ?? "")
        }

        Downloader.shared.download(url: urlField.text ?? "")
    }
}
