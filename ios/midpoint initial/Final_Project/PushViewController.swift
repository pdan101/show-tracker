//
//  ViewController.swift
//  rj284_p2
//
//  Created by Richard Jin on 10/2/21.
//

import UIKit

class PushViewController: UIViewController {

    private var nameLabel = UILabel()
    private var profileImageView = UIImageView()
    private var paimonImageView = UIImageView()
    private var saveButton = UIButton()
    private var aboutTextField = UITextField()
    private var nameTextField = UITextField()
    private var alert = UIAlertController(title:"Error", message:"Please type something for both name and about!", preferredStyle: .alert)


//    weak var delegate: UpdateAboutDelegate?
    private var placeholderText: String?

    init() {
//        self.delegate = delegate
        self.aboutTextField.text = "show"
        self.nameTextField.text = "show1"
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Edit Information"

        nameLabel.text = "My Profile"
        nameLabel.textColor = .systemBlue
        nameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        profileImageView.image = UIImage(named: "Aether")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)

        paimonImageView.image = UIImage(named: "Paimon")
        paimonImageView.contentMode = .scaleAspectFill
        paimonImageView.clipsToBounds = true
        paimonImageView.layer.cornerRadius = 5
        paimonImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paimonImageView)

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        view.addSubview(saveButton)

        aboutTextField.placeholder = "About"
        aboutTextField.textColor = .black
        aboutTextField.font = .systemFont(ofSize: 20)
        aboutTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboutTextField)

        nameTextField.placeholder = "Name"
        nameTextField.textColor = .black
        nameTextField.font = .systemFont(ofSize: 20)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)

        setupConstraints()


    }

    @objc func popViewController() {
        // TODO 9: call delegate function
//        if (self.aboutTextField.text != "") && (self.nameTextField.text != ""){
//            self.delegate?.updateAbout(newString: self.aboutTextField.text ?? "About", nameString: self.nameTextField.text ?? "Name")
//            self.navigationController?.popViewController(animated: true)
//        }
//        else{
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
//                self.navigationController?.popViewController(animated: true)
//            }))
//        }

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
            paimonImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            paimonImageView.heightAnchor.constraint(equalToConstant: 100),
            paimonImageView.widthAnchor.constraint(equalToConstant: 100),
            paimonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:130)
        ])

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            nameTextField.heightAnchor.constraint(equalToConstant: 17),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])

        NSLayoutConstraint.activate([
            aboutTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            aboutTextField.heightAnchor.constraint(equalToConstant: 17),
            aboutTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            aboutTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])


    }

}

