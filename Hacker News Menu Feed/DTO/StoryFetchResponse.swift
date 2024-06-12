struct StoryFetchResponse: Decodable, Hashable {
    let id: Int
    let by: String
    let score: Int
    let time: Int
    let type: String
    let comments: Int?
    let kids: [Int]?
    let title: String?
    let text: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case by = "by"
        case comments = "descendants"
        case kids = "kids"
        case score = "score"
        case time = "time"
        case title = "title"
        case text = "text"
        case type = "type"
        case url = "url"
    }
}

struct Story: Decodable {
    var id: Int
    var by: String
    var descendants: Int
    var kids: [Int]
    var score: Int
    var time: Int
    var title: String
    var type: String
    var text: String? // Ask story have text
    var url: String? // Ask story don't have url
}

struct Comment: Decodable {
    let id: Int
    let by: String
    let kids: [Int]
    let parent: Int
    let text: String
    let time: Int
    let type: String
}

struct Job: Decodable {
    let by: String
    let id: Int
    let score: Int
    let text: String
    let time: Int
    let title: String
    let type: String
    let url: String?
}
