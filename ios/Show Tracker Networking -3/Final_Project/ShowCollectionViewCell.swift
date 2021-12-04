import UIKit

class ShowCollectionViewCell: UICollectionViewCell {

    private var showImageView = UIImageView()
    private var nameLabel = UILabel()
    private var genreLabel = UILabel()
    private var startLabel = UILabel()
    private var yearLabel = UILabel()
    var textColor = UIColor.black

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white

        showImageView.contentMode = .scaleAspectFit
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(showImageView)
        
        nameLabel.contentMode = .scaleAspectFit
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        genreLabel.contentMode = .scaleAspectFit
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)

        startLabel.contentMode = .scaleAspectFit
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startLabel)
        
        yearLabel.contentMode = .scaleAspectFit
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(yearLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(imageURL : String){
        let imageUrl = URL(string: imageURL)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        self.showImageView.image = image
    }

    
    func getdate(show : Show) -> String {
        let ret:String = show.start_date ?? "n/a"
        return ret
    }
    func configure(for show: Show) {
        load(imageURL: show.image_url)
        nameLabel.text = show.name
        nameLabel.textColor = textColor
        nameLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        startLabel.text = "Date Started: " + getdate(show: show)
        startLabel.textColor = .gray
        startLabel.font = .systemFont(ofSize: 12.0, weight: .light)
        genreLabel.text = "Genre: " + show.genre
        genreLabel.textColor = .gray
        genreLabel.font = .systemFont(ofSize: 12.0, weight: .light)
        yearLabel.text = "Year Released: " + String(show.year_released)
        yearLabel.textColor = .gray
        yearLabel.font = .systemFont(ofSize: 12.0, weight: .light)
    }
    
    func updateData(genre: String, year: String){
        genreLabel.text = genre
//        ratingLabel.text = rating
        yearLabel.text = year
    }

    func setupConstraints() {
        let padding: CGFloat = 8
        let labelHeight: CGFloat = 15
        
        NSLayoutConstraint.activate([
            showImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            showImageView.heightAnchor.constraint(equalToConstant:100),
            showImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: showImageView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: showImageView.bottomAnchor, constant: padding),
            nameLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        NSLayoutConstraint.activate([
            genreLabel.centerXAnchor.constraint(equalTo: showImageView.centerXAnchor),
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            genreLabel.heightAnchor.constraint(equalToConstant: labelHeight-5)
        ])
        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: showImageView.centerXAnchor),
            startLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: padding),
            startLabel.heightAnchor.constraint(equalToConstant: labelHeight-5)
        ])
        NSLayoutConstraint.activate([
            yearLabel.centerXAnchor.constraint(equalTo: showImageView.centerXAnchor),
            yearLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: padding),
            yearLabel.heightAnchor.constraint(equalToConstant: labelHeight-5)
        ])
    }

}

