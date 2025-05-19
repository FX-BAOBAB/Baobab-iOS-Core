//
//  RightMessageTableCell.swift
//  Baobab
//
//  Created by 이정훈 on 4/21/25.
//

import UIKit

class RightMessageTableCell: UITableViewCell {
    class var reuseIdentifier: String {
        "RightMessageTableCell"
    }
    fileprivate let messageLabel: UILabel = {
        let label = PaddedLabel()
        label.layer.cornerRadius = 15
        label.backgroundColor = .gray1
        label.layer.masksToBounds = true
        
        return label
    }()
    private let sentTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
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
    
    fileprivate func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(sentTimeLabel)
        sentTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(messageLabel.snp.leading).offset(-3)
            make.bottom.equalToSuperview().inset(5)
            make.leading.greaterThanOrEqualToSuperview().inset(10)
        }
    }
    
    func configure(_ message: ChatMessage) {
        messageLabel.text = message.message
        sentTimeLabel.text = message.sentTime
    }

}

final class LoadingRightMessageTableViewCell: RightMessageTableCell {
    override class var reuseIdentifier: String {
        "LoadingRightMessageTableViewCell"
    }
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        
        return indicator
    }()
    
    override func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.trailing.equalTo(messageLabel.snp.leading)
        }
    }
    
    override func configure(_ message: ChatMessage) {
        messageLabel.text = message.message
    }
}
