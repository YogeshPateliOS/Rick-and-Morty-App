//
//  UIImageView + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

// https://stackoverflow.com/a/45183939/8201581
/*
 we have to keep track of (a) the current URLSessionTask associated with the last request; and (b) the current URL being requested. You can then (a) when starting a new request, make sure to cancel any prior request; and (b) when updating the image view, make sure the URL associated with the image matches what the current URL is.
 */


extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0
    // objc_getAssociatedObject. Returns the value associated with a given object for a given key.
    private var currentTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // Load Image Async with support cache - so it will not call api for every image.
    func loadImageAsync(with urlString: String?, placeholder: UIImage? = nil) {
        // cancel prior task, if any

        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()

        // reset image view’s image

        self.image = placeholder

        // allow supplying of `nil` to remove old image and then return immediately

        guard let urlString = urlString else { return }

        // check cache

        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }

        // download

        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil

            // error handling

            if let error = error {
                // don't bother reporting cancelation errors

                if (error as? URLError)?.code == .cancelled {
                    return
                }

                print(error)
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: urlString)

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        // save and start new task

        currentTask = task
        task.resume()
    }
}
