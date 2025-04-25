//
//  LeftProfileMessageTableCell.swift
//  Baobab
//
//  Created by 이정훈 on 4/24/25.
//

import UIKit

final class LeftProfileMessageTableCell: UITableViewCell {
    static let reuseIdentifier = "LeftProfileMessageTableCell"
    private let messageLabel: UILabel = {
        let label = PaddedLabel()
        label.layer.cornerRadius = 15
        label.backgroundColor = .accent
        label.layer.masksToBounds = true
        label.textColor = .white
        
        return label
    }()
    private let sentTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    private let nickNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        
        return label
    }()
    private let profileImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private var imageURL: URL? {
        willSet {
            if let url = newValue {
                profileImage.kf.indicatorType = .activity
                profileImage.kf.setImage(with: url)
                profileImage.layer.cornerRadius = 10
                profileImage.clipsToBounds = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
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
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
            make.bottom.equalTo(profileImage.snp.bottom)
        }
        
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        contentView.addSubview(sentTimeLabel)
        sentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageLabel.snp.trailing).offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func configure(_ message: ChatMessage) {
        messageLabel.text = message.message
        sentTimeLabel.text = message.sentTime
        nickNameLabel.text = message.nickname
        imageURL = URL(string: message.profileImageURL)
    }

}
