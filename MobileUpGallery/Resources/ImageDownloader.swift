import Nuke

class ImageDownloader {
    
    static func loadImage(with url: ImageRequestConvertible?, into view: ImageDisplayingView,
                          completion: ((_ result: Result<ImageResponse, ImagePipeline.Error>) -> Void)? = nil) {
        Nuke.loadImage(with: url, options: getOptions(), into: view, completion: completion)
    }
    
    static func getOptions() -> ImageLoadingOptions {
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "placeholder"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "oops")
        )
        
        return options
    }
}

