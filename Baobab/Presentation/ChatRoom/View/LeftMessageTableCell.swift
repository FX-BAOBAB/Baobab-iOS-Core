//
//  LeftMessageTableCell.swift
//  Baobab
//
//  Created by 이정훈 on 4/21/25.
//

import UIKit

final class LeftMessageTableCell: UITableViewCell {
    static let reuseIdentifier = "LeftMessageTableCell"
    private let messageLabel: UILabel = {
        let label = PaddedLabel()
        label.layer.cornerRadius = 15
        label.backgroundColor = .accent
        label.layer.masksToBounds = true
        label.textColor = .white
        
        return label
    }()
    private let dateLabel: UILabel = {
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
    
    private func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    func configure(_ message: ChatMessage) {
        messageLabel.text = message.message
    }

}
