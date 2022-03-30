import SwiftyVK

class VKRequestHandler {
    
    static func getAlbumPhotos() -> [Photo] {
        
        var photos: [Photo] = []
        
        let group = DispatchGroup()
        group.enter()
        
        VK.API.Photos.get([.ownerId: "-128666765", .albumId: "266276915", .rev: "0"])
            .onSuccess {
                let response = try! JSONDecoder().decode(ParsedResponse.self, from: $0)
                photos = response.photos
                group.leave()
            }
            .onError {
                print("Request failed with: \($0)")
                group.leave()
            }
            .send()
        
        group.wait()
        return photos
    }
}
