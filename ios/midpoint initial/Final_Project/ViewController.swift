//
//  ViewController.swift
//  sc2489_p5
//
//  Created by Siyuan Chen on 11/2/21.
//

import UIKit

protocol UpdateAboutDelegate: class {
    func updateAbout(watchStatus: Bool, genreString: String, ratingString: String, yearString: String, didSelectItemAt indexPath: IndexPath)
}


// TODO 6: create protocol to update title
//protocol UpdateTitleDelegate: class {
//    func updateTitle(newString: String)
//}
//
//protocol UpdateAboutDelegate: class {
//    func updateAbout(newString: String, nameString: String)
//}

class ViewController: UIViewController {

    // set up view
    private var collectionView: UICollectionView!
    private var planView: UICollectionView!
//    private var filterView: UICollectionView!
    private var watchListLabel = UILabel()
    private var planToWatchLabel = UILabel()
    private var addButton = UIButton()
    

    // Data
    private var currentWatch : [Show] = [Show(name: "The Walking Dead", genre: "Horror", year: 2010, rating: "4/5", watched: true),
                                         Show(name: "Game Of Thrones", genre: "Drama", year: 2011, rating: "4.5/5", watched: true),
                                         Show(name: "The Big Bang Theory", genre: "Comedy", year: 2007, rating: "4.5/5", watched: true),
                                         Show(name: "Squid Game", genre: "Thriller", year: 2021, rating: "4/5", watched: true),
                                         Show(name: "Family Guy", genre: "Comedy", year: 1999, rating: "3.5/5", watched: true),
                                         Show(name: "Friends", genre: "Sitcom", year: 1994, rating: "4.5/5", watched: true)
    
    ]
    
    private var planToWatch : [Show] = [Show(name: "South Park" ,genre: "Comedy", year: 1997, rating: "n/a", watched: false),
                                        Show(name: "The Office", genre: "Comedy", year: 2005, rating: "n/a", watched: false),
                                        Show(name: "Peaky Blinders", genre: "Action", year: 2013, rating: "n/a", watched: false),
                                        Show(name: "Narcos", genre: "Crime", year: 2018, rating: "n/a", watched: false),
                                        Show(name: "The Flash", genre: "Sci-Fi", year: 2014, rating: "n/a", watched: false)
    
    ]
    
//    private var filters : [Filter] = [Filter(name: "Mews"), Filter(name: "CKB"), Filter(name: "Donlon"), Filter(name: "Keeton"), Filter(name: "Bethe"), Filter(name: "Rose"), Filter(name: "Becker"), Filter(name: "Cook"), Filter(name: "Cascadilla"), Filter(name: "Edgemoor")]
    
    private var selectedShows : [Show] = []
//    private var clickedFilters: [Filter] = []

    // set up constants
    private let watchCellReuseIdentifier = "watchCellReuseIdentifier"
//    private let filterCellReuseIdentifier = "filterCellReuseIdentifier"
//    private let headerReuseIdentifier = "headerReuseIdentifer"
    private let planCellReuseIdentifier = "PlanCellReuseIdentifier"
    private let cellPadding: CGFloat = 10
    private let sectionPadding: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Show Tracker"
        view.backgroundColor = .white

        // Setup flow layout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = cellPadding
        collectionLayout.minimumInteritemSpacing = cellPadding
        collectionLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        
        
        
//        let filterLayout = UICollectionViewFlowLayout()
//        filterLayout.scrollDirection = .horizontal
//        filterLayout.minimumLineSpacing = cellPadding
//        filterLayout.minimumInteritemSpacing = cellPadding
//        filterLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: sectionPadding, bottom: sectionPadding, right: sectionPadding)

        // Instantiate collectionView and FilterView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        planView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        planView.backgroundColor = .clear
        planView.translatesAutoresizingMaskIntoConstraints = false
        
//        filterView = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
//        filterView.backgroundColor = .clear
//        filterView.translatesAutoresizingMaskIntoConstraints = false

        // Create collection view cell and filter view cell and register it here.
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: watchCellReuseIdentifier)
        planView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: planCellReuseIdentifier)
//        filterView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterCellReuseIdentifier)

        // Set collection view and filter view data source
        collectionView.dataSource = self
        planView.dataSource = self
//        filterView.dataSource = self

        // Set collection view and filter view delegate
        collectionView.delegate = self
        planView.delegate = self
//        filterView.delegate = self
        
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

        view.addSubview(collectionView)
        view.addSubview(planView)
//        view.addSubview(filterView)
        setupConstraints()
    }

    func setupConstraints() {
        let filterViewPadding: CGFloat = 12
//        NSLayoutConstraint.activate([
//            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: filterViewPadding),
//            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding),
//            filterView.heightAnchor.constraint(equalToConstant: 20),
//            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterViewPadding)
//        ])
        NSLayoutConstraint.activate([
            watchListLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            watchListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: watchListLabel.bottomAnchor, constant: filterViewPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: filterViewPadding),
            collectionView.heightAnchor.constraint(equalToConstant: 180),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -filterViewPadding)
        ])
        NSLayoutConstraint.activate([
            planToWatchLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
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
    @objc func pushViewControllerButtonPressed() {
        // TODO 3: create VC to push
        let vc = PushViewController()
        navigationController?.pushViewController(vc, animated: true)

    }

}

// TODO 4: Conform to UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == filterView {
//            return filters.count
//        }
        if collectionView == planView{
            return planToWatch.count
        }
        else{
            if selectedShows.isEmpty {
                return currentWatch.count
            }
            else{
                return selectedShows.count
            }
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == filterView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
//            let filter = filters[indexPath.row]
//            cell.configure(for: filter)
//            return cell
//        }
        if collectionView == planView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planCellReuseIdentifier, for: indexPath) as! ShowCollectionViewCell
            if selectedShows.isEmpty{
                let show = planToWatch[indexPath.item]
                cell.configure(for: show)
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
                let show = currentWatch[indexPath.item]
                cell.configure(for: show)
            }
            else{
                let show = selectedShows[indexPath.item]
                cell.configure(for: show)
            }
            return cell
        }
    }
    
}

// TODO 5: Confrom to UICollectionViewDelegateFlowLayout
// TODO 7: Conform to UICollectionViewDelegate, implement interaction
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == filterView{
//            let numItemsPerRow: CGFloat = 5.0
//            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
//            return CGSize(width: size, height: size)
//        }
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
            show = planToWatch[indexPath.item]
        }
        else{
            show = currentWatch[indexPath.item]
        }
        let vc = ShowPushViewController(delegate: self, indexPath: indexPath, name: show.getName(), watched: show.getWatchStatus(), oldGenre: show.getGenre(), oldRating: show.getRating(), oldYear: show.getYear())
        navigationController?.pushViewController(vc, animated: true)
        
        
//        if let cell = collectionView.cellForItem(at: indexPath) as? ShowCollectionViewCell {
//            let vc = ShowPushViewController(delegate: self, indexPath: indexPath)
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
}


extension ViewController: UpdateAboutDelegate {

    func updateAbout(watchStatus: Bool, genreString: String, ratingString: String, yearString: String, didSelectItemAt indexPath: IndexPath) {
        
        if watchStatus {
            if let cell = collectionView.cellForItem(at: indexPath) as? ShowCollectionViewCell {
                cell.updateData(genre: genreString, rating: ratingString, year: yearString)
            }
        }
        else{
            if let cell = planView.cellForItem(at: indexPath) as? ShowCollectionViewCell {
                cell.updateData(genre: genreString, rating: ratingString, year: yearString)
            }
        }
        
        
        
        
    }
}



//extension ViewController: UpdateTitleDelegate {
//
//    func updateTitle(newString: String) {
//        title = newString
//
//    }
//
//}
//
//extension ViewController: UpdateAboutDelegate {
//
//    func updateAbout(newString: String, nameString: String) {
//        aboutTextView.text = newString
//        nameLabel.text = nameString
//    }
//
//}


//    func collectionView(_ collectionView1: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView1 == collectionView{
//            if selectedDorms.isEmpty{
//                dorms[indexPath.item].isSelected.toggle()
//            }
//            else{
//                selectedDorms[indexPath.item].isSelected.toggle()
//            }
//            collectionView.reloadData()
//        }
//        else{
//            let filterLabel = filters[indexPath.row].label
//            filters[indexPath.row].isClicked.toggle()
//            if filters[indexPath.row].isClicked{
//                for dorm in dorms{
//                    if (dorm.name == filterLabel || dorm.location == filterLabel || dorm.rating == filterLabel) {
//                            selectedDorms.append(dorm)
//                        }
//                    }
//            }
//            else {
//                for dorm in dorms{
//                    if (dorm.name == filterLabel || dorm.location == filterLabel || dorm.rating == filterLabel) {
//                        if let index = selectedDorms.firstIndex(where: {$0.name == filterLabel || $0.rating == filterLabel || $0.location == filterLabel}){
//                            selectedDorms.remove(at: index)
//                        }
//                    }
//                }
//            }
//        }
//        print(selectedDorms)
//        collectionView1.reloadData()
//        collectionView.reloadData()
//    }



