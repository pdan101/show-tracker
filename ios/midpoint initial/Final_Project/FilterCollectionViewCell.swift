//
//  FilterCollectionViewCell.swift
//  sc2489_p5
//
//  Created by Siyuan Chen on 11/2/21.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white

        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for filter: Filter) {
        label.text = filter.label
        label.textAlignment = NSTextAlignment.center
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.cornerRadius = 35
        if filter.isClicked {
            label.textColor = .white
            label.backgroundColor = .systemBlue
        }
        else{
            label.textColor = .systemBlue
            label.backgroundColor = .clear
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}

