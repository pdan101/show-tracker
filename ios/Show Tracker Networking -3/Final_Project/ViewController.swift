import UIKit
import Alamofire

//delegate for deleting shows
protocol UpdateAboutDelegate: class {
    func deleteSelf(startDate: String, showID: Int)
}

//delegate for adding shows
protocol AddToWatchDelegate: class {
    func addToWatch(name: String, year_released: Int, start_date: String, finished: Bool, genre: String)
    func addToWatchPlan(name: String, year_released: Int, genre: String)
}

//view controller object, miust conform for searching
class ViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchTextCurrent(searchBar.text!)
        filterContentForSearchTextPlan(searchBar.text!)
    }
    
// state variable
    private var login : Bool = false
    
// objects for logging in
    private var number: Int? = nil
    private var refreshButton = UIButton()
    private var userBox = UITextField()
    
    private var loginTitle = UILabel()
    private var message1 = UILabel()
    
    private var currentWatchView: UICollectionView!
    private var planView: UICollectionView!
    private var watchListLabel = UILabel()
    private var planToWatchLabel = UILabel()
    private var addButton = UIButton()
    private var filteredCurrent: [Show] = []
    private var filteredPlan: [Show] = []
    private var searchCurrentEmpty: Bool {
        return currentSearchController.searchBar.text?.isEmpty ?? true
    }
    private let currentSearchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
      return currentSearchController.isActive && !searchCurrentEmpty
    }
    private var currentWatch: [Show] = []
    private var planToWatch: [Show] = []
    
//method to getwatchlist using the network function
    func getWatchlist() {
        if number != nil {
            NetworkManager.getWatchlist(userId: number!) { shows in
                self.currentWatch = shows
                DispatchQueue.main.async {
                    self.currentWatchView.reloadData()
                }
            }
        } else {
            userBox.text = "USERNAME REQUIRED"
        }
    }
    
//method to getplanlist using the network function
    func getPlanWatchlist() {
        if number != nil {
            NetworkManager.getPlanWatchlist(userId: number!){ shows in
                self.planToWatch = shows
                DispatchQueue.main.async {
                    self.planView.reloadData()
                }
            }
        } else {
            userBox.text = "USERNAME REQUIRED"
        }
    }

    private var selectedShows : [Show] = []

    // set up constants
    private let watchCellReuseIdentifier = "watchCellReuseIdentifier"
    private let planCellReuseIdentifier = "PlanCellReuseIdentifier"
    private let cellPadding: CGFloat = 10
    private let sectionPadding: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        if (login == false){
            setUpLoginPage()
        }
        else{
            setUpMainPage()
        }
    }

// helper function to return a list of show names from a list of shows
    func getNames(shows: [Show]) -> [String] {
        var ret: [String] = []
        for s in shows {
            print(s.name)
            ret.append(s.name)
        }
        return ret
    }
    
    
// function called when logging in
    @objc func refreshData() {
        if userBox.text != "" {
            let username = userBox.text
            NetworkManager.getUser(username: username!) { user in
                    let userID = user.getID()
                    self.number = userID
    
                print("User ID: \(self.number!)")
                self.getWatchlist()
                self.getPlanWatchlist()
            }
            login = true
            self.loginTitle.isHidden = true
            self.message1.isHidden = true
            userBox.isHidden = true
            refreshButton.isHidden = true
            addButton.isHidden = false
            self.viewDidLoad()
        }
        else {
            userBox.text = "USERNAME REQUIRED"
        }
    }
    
    func setUpLoginPage(){
        view.backgroundColor = .white
        
        loginTitle.text = "Welcome to Show Tracker"
        loginTitle.textColor = .black
        loginTitle.font = .systemFont(ofSize: 30, weight: .bold)
        loginTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTitle)
        
        message1.text = "Please enter your name:"
        message1.textColor = .darkGray
        message1.font = .systemFont(ofSize: 18, weight: .medium)
        message1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(message1)
        
        refreshButton.setTitle("Login", for: .normal)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        refreshButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.borderColor = UIColor.systemBlue.cgColor
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.7)
        refreshButton.layer.cornerRadius = 15
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        view.addSubview(refreshButton)
        
        userBox.placeholder = "Username"
        userBox.textColor = .black
        userBox.font = .systemFont(ofSize: 20)
        userBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userBox)
        
        setUpLoginConstraints()
    }
    
    func setUpMainPage(){
        title = "Show Tracker"
        view.backgroundColor = .white

        // Setup flow layout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = cellPadding
        collectionLayout.minimumInteritemSpacing = cellPadding
        collectionLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        let collectionLayout2 = UICollectionViewFlowLayout()
        collectionLayout2.scrollDirection = .horizontal
        collectionLayout2.minimumLineSpacing = cellPadding
        collectionLayout2.minimumInteritemSpacing = cellPadding
        collectionLayout2.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)

        currentWatchView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        currentWatchView.backgroundColor = .clear
        currentWatchView.translatesAutoresizingMaskIntoConstraints = false
        
        planView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout2)
        planView.backgroundColor = .clear
        planView.translatesAutoresizingMaskIntoConstraints = false

        currentWatchView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: watchCellReuseIdentifier)
        planView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: planCellReuseIdentifier)
        
        currentWatchView.dataSource = self
        planView.dataSource = self

        currentWatchView.delegate = self
        planView.delegate = self
        
        currentSearchController.searchResultsUpdater = self
        currentSearchController.obscuresBackgroundDuringPresentation = false
        currentSearchController.searchBar.placeholder = "Search Shows"
        navigationItem.searchController = currentSearchController
        definesPresentationContext = true
        
        watchListLabel.text = "Your Watch List"
        watchListLabel.textColor = .black
        watchListLabel.font = .systemFont(ofSize: 22, weight: .bold)
        watchListLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(watchListLabel)
        
        planToWatchLabel.text = "Your Plan-To-Watch List"
        planToWatchLabel.textColor = .black
        planToWatchLabel.font = .systemFont(ofSize: 22, weight: .bold)
        planToWatchLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(planToWatchLabel)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        addButton.layer.cornerRadius = 4
        addButton.addTarget(self, action: #selector(pushViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(addButton)
        view.addSubview(currentWatchView)
        view.addSubview(planView)

        setupConstraints()
    }

    func setupConstraints() {
        let filterViewPadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            watchListLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            watchListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding)
        ])
        NSLayoutConstraint.activate([
            currentWatchView.topAnchor.constraint(equalTo: watchListLabel.bottomAnchor, constant: filterViewPadding),
            currentWatchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding),
            currentWatchView.heightAnchor.constraint(equalToConstant: 180),
            currentWatchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterViewPadding)
        ])
        NSLayoutConstraint.activate([
            planToWatchLabel.topAnchor.constraint(equalTo: currentWatchView.bottomAnchor, constant: 20),
            planToWatchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding)
        ])
        NSLayoutConstraint.activate([
            planView.topAnchor.constraint(equalTo: planToWatchLabel.bottomAnchor, constant: filterViewPadding),
            planView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding),
            planView.heightAnchor.constraint(equalToConstant: 180),
            planView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterViewPadding)
        ])
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: planView.bottomAnchor, constant: filterViewPadding),
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setUpLoginConstraints() {
        let loginViewPadding: CGFloat = 15
        NSLayoutConstraint.activate([
            message1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            message1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginViewPadding),
            message1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginViewPadding),
            message1.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            loginTitle.bottomAnchor.constraint(equalTo: message1.topAnchor, constant: -loginViewPadding),
            loginTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitle.heightAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            userBox.topAnchor.constraint(equalTo: message1.bottomAnchor, constant: loginViewPadding),
            userBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginViewPadding),
            userBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginViewPadding),
            userBox.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: userBox.bottomAnchor, constant: loginViewPadding),
            refreshButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            refreshButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
//viewcontroller pushed when add show is pressed
    @objc func pushViewControllerButtonPressed() {
        let vc = PushViewController(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }

}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currentWatchView{
                if isFiltering == true {
                    return filteredCurrent.count
                } else {
                return currentWatch.count
                }
        }
        else {
                if isFiltering == true {
                    return filteredPlan.count
                } else {
                return planToWatch.count
                }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == planView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planCellReuseIdentifier, for: indexPath) as! ShowCollectionViewCell
            if selectedShows.isEmpty{
                if isFiltering == true {
                    let show = filteredPlan[indexPath.item]
                    cell.configure(for: show)
                } else {
                let show = planToWatch[indexPath.item]
                cell.configure(for: show)
                }
            }
            else{
                let show = selectedShows[indexPath.item]
                cell.configure(for: show)
            }
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: watchCellReuseIdentifier, for: indexPath) as! ShowCollectionViewCell
            if selectedShows.isEmpty{
                if isFiltering == true {
                    let show = filteredCurrent[indexPath.item]
                    cell.configure(for: show)
                } else {
                let show = currentWatch[indexPath.item]
                cell.configure(for: show)
                }
            }
            else{
                let show = selectedShows[indexPath.item]
                cell.configure(for: show)
            }
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == planView{
            let numItemsPerRow: CGFloat = 2.0
            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
            return CGSize(width: size, height: size)
        }
        else{
            let numItemsPerRow: CGFloat = 2.0
            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var show : Show
        if (collectionView == planView){
            if isFiltering == true {
                show = filteredPlan[indexPath.item]
            } else {
            show = planToWatch[indexPath.item]
            }
        }
        else{
            if isFiltering == true {
                show = filteredCurrent[indexPath.item]
            } else {
            show = currentWatch[indexPath.item]
            }
        }
        let vc = ShowPushViewController(indexPath: indexPath, id: show.getID(), name: show.getName(), genre: show.getGenre(), year_released: show.getYear(), start_date: show.getStart(), finished: show.getFinished(), image_url: show.getImage(), delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController: UpdateAboutDelegate {
    func deleteSelf(startDate: String, showID: Int) {
        if startDate != "n/a" {
            NetworkManager.deleteCurrentWatch(showID: showID, userID: self.number!) { show in
                for show in self.currentWatch{
                    if (show.id == showID) {
                        if let index = self.currentWatch.firstIndex(where: {$0.id == show.id}){
                            self.currentWatch.remove(at: index)
                            DispatchQueue.main.async {
                                self.currentWatchView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
        else{
            NetworkManager.deletePlanWatch(showID: showID, userID: self.number!) { show in
                for show in self.planToWatch{
                    if (show.id == showID) {
                        if let index = self.planToWatch.firstIndex(where: {$0.id == show.id}){
                            self.planToWatch.remove(at: index)
                            DispatchQueue.main.async {
                                self.planView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
    }


extension ViewController: AddToWatchDelegate {
    func addToWatch(name: String, year_released: Int, start_date: String, finished: Bool, genre: String) {
        var isAlreadyIn = 0
        for show in currentWatch{
            if (show.name == name){
                isAlreadyIn = 1
            }
        }
        if (isAlreadyIn == 0){
            if number != nil {
            let username = userBox.text
            NetworkManager.getUser(username: username!) { user in
                let id = user.getID()
                NetworkManager.makePostWatchlist(name: name, year_released: year_released, start_date: start_date, finished: finished, genre: genre, user_id: id) { show in
                    self.currentWatch.append(show)
                    DispatchQueue.main.async {
                        self.currentWatchView.reloadData()
                    }
                }
                }
            } else {
                userBox.text = "USERNAME REQUIRED"
            }
        }
        
    }
    func addToWatchPlan(name: String, year_released: Int, genre: String) {
        var isAlreadyIn = 0
        for show in planToWatch{
            if (show.name == name){
                isAlreadyIn = 1
            }
        }
        if (isAlreadyIn == 0){
            if number != nil {
            let username = userBox.text
            NetworkManager.getUser(username: username!) { user in
                let id = user.getID()
                NetworkManager.makePostPlanList(name: name, year_released: year_released, genre: genre, user_id: id) { show in
                    self.planToWatch.append(show)
                    DispatchQueue.main.async {
                        self.planView.reloadData()
                    }
                }
                }
            } else {
                userBox.text = "USERNAME REQUIRED"
            }
        }
    }
    
    func filterContentForSearchTextCurrent(_ searchText: String) {
        filteredCurrent = currentWatch.filter { (show: Show) -> Bool in
        return show.name.lowercased().contains(searchText.lowercased())
      }
      
      currentWatchView.reloadData()
    }
    
    func filterContentForSearchTextPlan(_ searchText: String) {
        filteredPlan = planToWatch.filter { (show: Show) -> Bool in
        return show.name.lowercased().contains(searchText.lowercased())
      }
      
      planView.reloadData()
    }
}
