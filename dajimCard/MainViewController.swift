import UIKit
import PhotosUI

// 다짐 카드 한장을 만드는 Entry 구조체 (모달의 입력영역!)
struct Entry {
    let title: String
    let content: String
    let image: UIImage?
    let createdAt: Date
}

final class MainViewController: UIViewController {

    private let backgroundImageView = UIImageView()

    // 컬렉션뷰 + 하단 버튼
    private var collectionView: UICollectionView!
    private let addEntryButton = UIButton(type: .system)

    // 데이터
    private var entries: [Entry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "내일배움캠프를 시작하며"

        setupBackground()
        setupNavBar()
        setupAddEntryButton()
        setupCollectionView()
    }

    // MARK: - UI 구성

    private func setupBackground() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "배경 변경",
            style: .plain,
            target: self,
            action: #selector(changeBackgroundTapped)
        )
    }

    @objc private func changeBackgroundTapped() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.view.tag = 1001
        present(picker, animated: true)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let horizontalPadding: CGFloat = 16
        let interItemSpacing: CGFloat = 10
        let columns: CGFloat = 2
        let totalSpacing = (interItemSpacing * (columns - 1)) + (horizontalPadding * 2)
        let itemWidth = (view.bounds.width - totalSpacing) / columns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 80)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseID)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addEntryButton.topAnchor, constant: -12)
        ])
    }

    private func setupAddEntryButton() {
        addEntryButton.setTitle("다짐 입력하기", for: .normal)
        addEntryButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addEntryButton.backgroundColor = .systemBlue
        addEntryButton.tintColor = .white
        addEntryButton.layer.cornerRadius = 12
        addEntryButton.addTarget(self, action: #selector(presentEditor), for: .touchUpInside)

        view.addSubview(addEntryButton)
        addEntryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addEntryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addEntryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addEntryButton.widthAnchor.constraint(equalToConstant: 200),
            addEntryButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        
        view.bringSubviewToFront(addEntryButton)
    }

    @objc private func presentEditor() {
        let editor = EntryEditorViewController()
        editor.onSave = { [weak self] entry in
            guard let self = self else { return }
            self.entries.insert(entry, at: 0)
            self.collectionView.reloadData()
        }

        let nav = UINavigationController(rootViewController: editor)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
}


// MARK: - PHPicker 델리게이트
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self = self, let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                if picker.view.tag == 1001 {
                    self.backgroundImageView.image = image
                }
            }
        }
    }
}

// MARK: - 컬렉션뷰 데이터소스/델리게이트
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseID, for: indexPath) as! CardCell
        cell.configure(with: entries[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entry = entries[indexPath.item]
        guard let img = entry.image else { return }

        let vc = UIViewController()
        vc.view.backgroundColor = .black
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.frame = vc.view.bounds
        iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.addSubview(iv)
        present(vc, animated: true)
    }
}


