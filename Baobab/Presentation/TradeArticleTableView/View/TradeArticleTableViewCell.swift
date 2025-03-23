//
//  TradeArticleTableViewCell.swift
//  Baobab
//
//  Created by 이정훈 on 3/13/25.
//

import UIKit
import Kingfisher

final class TradeArticleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TradeArticleTableViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(for: .subheadline, weight: .bold)
        label.textColor = .accent
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "원"
        label.font = UIFont.font(for: .subheadline, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(for: .caption1, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private var imageURL: URL? {
        willSet {
            if let url = newValue {
                thumbnail.kf.indicatorType = .activity
                thumbnail.kf.setImage(with: url)
                thumbnail.layer.cornerRadius = 10
                thumbnail.clipsToBounds = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setLayout() {
        contentView.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(UIScreen.main.bounds.width * 0.25)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(thumbnail.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(thumbnail.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(thumbnail.snp.trailing).offset(10)
        }
        
        contentView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(priceLabel.snp.trailing).offset(1)
        }
    }
    
    func configure(with item: TradeArticle) {
        titleLabel.text = item.title
        priceLabel.text = String(item.price)
        dateLabel.text = item.registeredAt ?? ""
        imageURL = item.imageMetadata.first?.imageURL
    }

}
