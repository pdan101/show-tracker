//
//  ShowPushViewController.swift
//  Final_Project
//
//  Created by Richard Jin on 11/24/21.
//
import UIKit

class ShowPushViewController: UIViewController {

    private var nameLabel = UILabel()
    private var profileImageView = UIImageView()
    private var saveButton = UIButton()
    private var genreTextField = UITextField()
    private var ratingTextField = UITextField()
    private var yearTextField = UITextField()
    private var alert = UIAlertController(title:"Error", message:"Please type something for both name and about!", preferredStyle: .alert)
    private var index = IndexPath()
    weak var delegate: UpdateAboutDelegate?
    var watchStatus: Bool
    
//    weak var delegate: UpdateAboutDelegate?
    private var placeholderText: String?

    init(delegate: UpdateAboutDelegate?, indexPath: IndexPath, name: String, watched: Bool, oldGenre: String, oldRating: String, oldYear: String) {
//        self.delegate = delegate
        watchStatus = watched
        nameLabel.text = name
        profileImageView.image = UIImage(named: name)
        self.genreTextField.text = oldGenre
        self.ratingTextField.text = oldRating
        self.yearTextField.text = oldYear
        self.index = indexPath
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

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        view.addSubview(saveButton)

        genreTextField.placeholder = "Genre"
        genreTextField.textColor = .black
        genreTextField.font = .systemFont(ofSize: 20)
        genreTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreTextField)

        ratingTextField.placeholder = "Rating"
        ratingTextField.textColor = .black
        ratingTextField.font = .systemFont(ofSize: 20)
        ratingTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingTextField)
        
        yearTextField.placeholder = "Year"
        yearTextField.textColor = .black
        yearTextField.font = .systemFont(ofSize: 20)
        yearTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yearTextField)
        
        setupConstraints()
    }

    @objc func popViewController() {
        // TODO 9: call delegate function
        
        if (self.genreTextField.text != "") && (self.ratingTextField.text != "") && (self.yearTextField.text != ""){
            self.delegate?.updateAbout(watchStatus: self.watchStatus, genreString: self.genreTextField.text ?? "Genre", ratingString: self.ratingTextField.text ?? "Rating", yearString: self.yearTextField.text ?? "Year", didSelectItemAt: index)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
                self.navigationController?.popViewController(animated: true)
            }))
        }

        self.navigationController?.popViewController(animated: true)
        self.present(alert, animated: true, completion: nil)

        // TODO 5: dismiss view controller

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
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            genreTextField.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            genreTextField.heightAnchor.constraint(equalToConstant: 17),
            genreTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            genreTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            genreTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])

        NSLayoutConstraint.activate([
            ratingTextField.topAnchor.constraint(equalTo: genreTextField.bottomAnchor, constant: 40),
            ratingTextField.heightAnchor.constraint(equalToConstant: 17),
            ratingTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            ratingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            ratingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            yearTextField.topAnchor.constraint(equalTo: ratingTextField.bottomAnchor, constant: 40),
            yearTextField.heightAnchor.constraint(equalToConstant: 17),
            yearTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            yearTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            yearTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])


    }

}

