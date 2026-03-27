import Foundation

class Downloader: NSObject, URLSessionDownloadDelegate {

    static let shared = Downloader()
    
    var progressHandler: ((Float) -> Void)?
    var completion: ((URL?) -> Void)?

    func download(url: String) {
        guard let fileURL = URL(string: url) else { return }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: fileURL)
        task.resume()
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progressHandler?(progress)
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destination = documents.appendingPathComponent(downloadTask.response!.suggestedFilename ?? "file")

        try? FileManager.default.moveItem(at: location, to: destination)

        DispatchQueue.main.async {
            self.completion?(destination)
        }
    }
}
