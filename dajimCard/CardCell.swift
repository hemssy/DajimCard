import UIKit

final class CardCell: UICollectionViewCell {
    static let reuseID = "CardCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let vStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.masksToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        contentLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 2

        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let imageContainer = UIView()
        imageContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor)
        ])

        vStack.addArrangedSubview(imageContainer)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(contentLabel)

        contentView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with entry: Entry) {
        imageView.image = entry.image ?? UIImage(systemName: "photo")
        titleLabel.text = entry.title
        contentLabel.text = "💬 " + entry.content
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
