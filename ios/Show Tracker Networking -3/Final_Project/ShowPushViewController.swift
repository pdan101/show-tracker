
import UIKit

class ShowPushViewController: UIViewController {

    private var nameLabel = UILabel()
    private var profileImageView = UIImageView()
    private var deleteButton = UIButton()
    private var genreLabel = UILabel()
    private var yearLabel = UILabel()
    private var startLabel = UILabel()
    private var index = IndexPath()
    weak var delegate: UpdateAboutDelegate?
    var watchStatus: Bool?
    var id: Int
    var name: String
    var startOpt: String?
    
    private var placeholderText: String?
    
    func getFin(finished: Bool?) -> Bool {
        if finished == nil {
            return false
        } else {
            return finished!
        }
    }
    
    func getStart(start: String?) -> String {
        if start == nil {
            return "n/a"
        } else {
            return start!
        }
    }
    

    init(indexPath: IndexPath, id: Int, name: String, genre: String, year_released: Int, start_date: String?, finished: Bool?, image_url: String, delegate: UpdateAboutDelegate?) {
        self.delegate = delegate
        nameLabel.text = "name: " + name
        self.genreLabel.text = "genre: " + genre
        self.yearLabel.text = "year released: " + String(year_released)
        self.index = indexPath
        self.id = id
        self.name = name
        self.startOpt = start_date
        super.init(nibName: nil, bundle: nil)
        self.startLabel.text = "date started: " + getStart(start: start_date)
        load(imageURL: image_url)
        self.watchStatus = getFin(finished: finished)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = name

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        deleteButton.setTitle("delete", for: .normal)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        deleteButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.systemBlue.cgColor
        deleteButton.layer.cornerRadius = 10
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(popViewControllerForDelete), for: .touchUpInside)
        view.addSubview(deleteButton)

        genreLabel.textColor = .black
        genreLabel.font = .systemFont(ofSize: 20, weight: .bold)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreLabel)

        yearLabel.textColor = .black
        yearLabel.font = .systemFont(ofSize: 20, weight: .bold)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yearLabel)
        
        startLabel.textColor = .black
        startLabel.font = .systemFont(ofSize: 20, weight: .bold)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startLabel)
        
        setupConstraints()
    }

    
    @objc func popViewControllerForDelete() {
        let startDate = getStart(start: startOpt)
        self.delegate?.deleteSelf(startDate: startDate, showID: id)
        self.navigationController?.popViewController(animated: true)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 260),
            profileImageView.widthAnchor.constraint(equalToConstant: 260),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            genreLabel.heightAnchor.constraint(equalToConstant: 25),
            genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            yearLabel.heightAnchor.constraint(equalToConstant: 25),
            yearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 20),
            startLabel.heightAnchor.constraint(equalToConstant: 25),
            startLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
    
    func load(imageURL : String){
        let imageUrl = URL(string: imageURL)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        self.profileImageView.image = image
    }

}

