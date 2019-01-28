import Foundation

class Player: Codable {
    var name = ""
    var ChineseName = ""
    var nation = ""
    var image = ""
    var background = ""
    var birth = ""
    var GSnum = 0
    var favorate = false
    var introduce = ""
    var rating = ""


    init(name: String, ChineseName: String, nation: String, image: String, background: String, birth: String, GSnum: Int, favorate: Bool, introduce: String, rating: String) {
        self.name = name
        self.ChineseName = ChineseName
        self.nation = nation
        self.image = image
        self.background = background
        self.birth = birth
        self.GSnum = GSnum
        self.favorate = favorate
        self.introduce = introduce
        self.rating = rating
    }
}

struct Nation: Codable {
    // 洲
    var continent = ""
    // 国家
    var countries = [String]()
}
