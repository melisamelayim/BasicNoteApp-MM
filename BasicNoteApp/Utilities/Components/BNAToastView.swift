//
//  ToastMessageView.swift
//  BasicNoteApp
//
//  Created by Max on 14.04.2025.
//

import UIKit

class BNAToastView: UIView {

    private let messageLabel = UILabel()

    init(message: String, backgroundColor: UIColor = .systemRed) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setupMessageLabel(message)
        setupLayout()
        self.alpha = 0
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMessageLabel(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.inter(.title3)
        messageLabel.textAlignment = .center
    }

    private func setupLayout() {
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func show(in view: UIView, duration: TimeInterval = 3.0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
