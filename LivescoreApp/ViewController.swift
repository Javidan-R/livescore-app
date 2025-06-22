import UIKit

struct Game {
    let id: String
    let team1: String
    let team2: String
    let score: String
    var isFavorite: Bool
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gameList: UITableView!
    var games: [Game] = [
        Game(id: "1", team1: "Barcelona", team2: "Real Madrid", score: "2 - 1", isFavorite: false),
        Game(id: "2", team1: "Liverpool", team2: "Man United", score: "0 - 0", isFavorite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController loaded, isLoggedIn: \(UserDefaults.standard.bool(forKey: "isLoggedIn"))")
        gameList.dataSource = self
        gameList.delegate = self
        gameList.register(UITableViewCell.self, forCellReuseIdentifier: "GameCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if user is logged in
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            print("Not logged in, redirecting to LoginController")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")
            // Use modern approach to set root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UINavigationController(rootViewController: loginVC)
                window.makeKeyAndVisible()
            }
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        let game = games[indexPath.row]
        cell.textLabel?.text = "\(game.team1) \(game.score) \(game.team2)"
        cell.accessoryType = game.isFavorite ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        games[indexPath.row].isFavorite.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let favorites = games.filter { $0.isFavorite }.map { $0.id }
        UserDefaults.standard.set(favorites, forKey: "favoriteGames")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    @IBAction func countryAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toCountries", sender: nil)
    }
    
    @IBAction func favoritesAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toFavorites", sender: nil)
    }
}
