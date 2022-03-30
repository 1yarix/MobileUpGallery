struct ParsedResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case count
        case photos = "items"
    }
    
    let count: Int
    let photos: [Photo]
}
