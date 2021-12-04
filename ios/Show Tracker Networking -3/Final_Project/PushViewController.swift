
import UIKit

class PushViewController: UIViewController {

    private var nameTextField = UITextField()
    private var genreTextField = UITextField()
    private var year_releasedTextField = UITextField()
    private var start_dateTextField = UITextField()
    private var profileImageView = UIImageView()
    weak var delegate: AddToWatchDelegate?
    private var index = IndexPath()
    private var saveButton = UIButton()
    private var savePlanButton = UIButton()
    private var alert = UIAlertController(title:"Error", message:"Please fill out every text field!", preferredStyle: .alert)


    private var placeholderText: String?

    init(delegate: AddToWatchDelegate?) {
        self.nameTextField.placeholder = "Show Name"
        self.genreTextField.placeholder = "Show Genre"
        self.year_releasedTextField.placeholder = "Year Released"
        self.start_dateTextField.placeholder = "Start of watching date"
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Edit Information"

        nameTextField.textColor = .systemBlue
        nameTextField.font = .systemFont(ofSize: 26, weight: .bold)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        saveButton.setTitle("Save To Watch List", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.7)
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.cornerRadius = 15
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        view.addSubview(saveButton)
        
        savePlanButton.setTitle("Save to Plan-To-Watch List", for: .normal)
        savePlanButton.setTitleColor(.white, for: .normal)
        savePlanButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.7)
        savePlanButton.layer.borderWidth = 1
        savePlanButton.layer.borderColor = UIColor.systemBlue.cgColor
        savePlanButton.layer.cornerRadius = 15
        savePlanButton.translatesAutoresizingMaskIntoConstraints = false
        savePlanButton.addTarget(self, action: #selector(popViewControllerForPlan), for: .touchUpInside)
        view.addSubview(savePlanButton)

        year_releasedTextField.textColor = .black
        year_releasedTextField.font = .systemFont(ofSize: 20)
        year_releasedTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(year_releasedTextField)

        genreTextField.textColor = .black
        genreTextField.font = .systemFont(ofSize: 20)
        genreTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreTextField)
        
        start_dateTextField.textColor = .black
        start_dateTextField.font = .systemFont(ofSize: 20)
        start_dateTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(start_dateTextField)


        setupConstraints()


    }

    @objc func popViewController() {
        let stringYear: String = year_releasedTextField.text ?? "0"
        let yearInt = Int(stringYear)
        if year_releasedTextField.text != ""{
        self.delegate?.addToWatch(name: self.nameTextField.text ?? "Unknown Name", year_released: yearInt!, start_date: start_dateTextField.text ?? "Unknown Date", finished: true, genre: genreTextField.text ?? "Unknown Genre")
        self.navigationController?.popViewController(animated: true)
        } else {
            year_releasedTextField.text = "Enter year released"
        }


    }
    
    @objc func popViewControllerForPlan() {
        let stringYear: String = year_releasedTextField.text ?? "0"
        let yearInt = Int(stringYear)
        
        if year_releasedTextField.text != ""{
        self.delegate?.addToWatchPlan(name: self.nameTextField.text ?? "Unknown Name", year_released: yearInt!, genre: genreTextField.text ?? "Unknown Genre")
        self.navigationController?.popViewController(animated: true)
        } else {
            year_releasedTextField.text = "Enter year released"
        }

    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            genreTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            genreTextField.heightAnchor.constraint(equalToConstant: 17),
            genreTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            start_dateTextField.topAnchor.constraint(equalTo: genreTextField.bottomAnchor, constant: 50),
            start_dateTextField.heightAnchor.constraint(equalToConstant: 17),
            start_dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            year_releasedTextField.topAnchor.constraint(equalTo: start_dateTextField.bottomAnchor, constant: 50),
            year_releasedTextField.heightAnchor.constraint(equalToConstant: 17),
            year_releasedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: year_releasedTextField.bottomAnchor, constant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 300),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            savePlanButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            savePlanButton.widthAnchor.constraint(equalToConstant: 300),
            savePlanButton.heightAnchor.constraint(equalToConstant: 50),
            savePlanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])


    }

}

