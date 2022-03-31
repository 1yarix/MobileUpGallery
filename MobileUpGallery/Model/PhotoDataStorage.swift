import UIKit

class PhotoDataStorage {
        
    static private(set) var photos: [Photo] = []
    static var loadedPhotos: [Int: (date: Int, image: UIImage)] = [:]
    
    static func getPhotos() throws -> [Photo]{
        photos = try VKRequestHandler.getAlbumPhotos()
        filterUrls()
        return photos
    }
    
    static private func filterUrls() {
       photos = photos.map({
           var photo = $0
           photo.sizes = photo.sizes.filter({$0.type == "w"})
           return photo
        })
    }
}
