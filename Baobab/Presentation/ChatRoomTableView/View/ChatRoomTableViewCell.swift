//
//  ChatRoomTableViewCell.swift
//  Baobab
//
//  Created by 이정훈 on 4/4/25.
//

import UIKit

final class ChatRoomTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatRoomTableViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    private let lastChatDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    private let thumbnail: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private var imageURL: URL? {
        willSet {
            if let url = newValue {
                thumbnail.kf.indicatorType = .activity
                thumbnail.kf.setImage(with: url)
                thumbnail.layer.cornerRadius = UIScreen.main.bounds.width * 0.15 / 2
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
            make.width.height.equalTo(UIScreen.main.bounds.width * 0.15)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(thumbnail.snp.trailing).offset(10)
        }
        
        contentView.addSubview(lastChatDateLabel)
        lastChatDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(thumbnail.snp.trailing).offset(10)
        }
    }
    
    func configure(with item: ChatRoom) {
        imageURL = item.thumbnailURL
        titleLabel.text = item.title
        lastChatDateLabel.text = item.lastChatAt
    }

}
