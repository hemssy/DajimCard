import UIKit
import PhotosUI

// 한 장의 다짐 카드를 만드는 구조체
struct Entry {
    let title: String // 다짐의 제목
    let content: String // 다짐의 내용
    let image: UIImage? // 저장하는 이미지
    let createdAt: Date // 저장된 시간
}

final class MainViewController: UIViewController {
    
    private let backgroundImageView = UIImageView() // 배경 이미지
    
    // 제목, 내용
    private let titleField = UITextField()
    private let contentTextView = UITextView()
    
    // 이미지 선택 버튼/뷰/저장 버튼
    private let pickImageButton = UIButton(type: .system)
    private let pickedImageView = UIImageView()
    private let saveButton = UIButton(type: .system)

        //저장된 다짐카드들을 보여줄 테이블뷰
    private let tableView = UITableView(frame: .zero, style: .plain)
        
        //실제 데이터를 저장할 배열
    private var entries: [Entry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "내일배움캠프를 시작하며"
                
                // 초기화면
        setupBackground()
        setupNavBar()
        setupInputArea()
        setupTableView()
    }
        
        // 배경 이미지뷰
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
    
        // 네비게이션 바 우측의 "배경 변경" 버튼
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "배경 변경",
            style: .plain,
            target: self,
            action: #selector(changeBackgroundTapped)
        )
    }
        
        // 배경 변경 버튼 눌렀을 때 앨범에서 이미지 선택하기
    @objc private func changeBackgroundTapped() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.view.tag = 1001 // 배경 이미지 선택인거 구분!
        present(picker, animated: true)
    }
    
    // 다짐 입력 부분
    private func setupInputArea() {
        titleField.placeholder = "제목 입력"
        titleField.borderStyle = .roundedRect

        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.separator.cgColor
        contentTextView.layer.cornerRadius = 8
        contentTextView.text = "오늘의 학습 목표 또는 다짐을 적어보세요."
        contentTextView.textColor = .secondaryLabel
        contentTextView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        contentTextView.delegate = self

        pickImageButton.setTitle("이미지 선택", for: .normal)
        pickImageButton.addTarget(self, action: #selector(pickCardImageTapped), for: .touchUpInside)

        pickedImageView.contentMode = .scaleAspectFill
        pickedImageView.clipsToBounds = true
        pickedImageView.layer.cornerRadius = 8
        pickedImageView.backgroundColor = .secondarySystemBackground
        pickedImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        saveButton.setTitle("다짐 저장", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
                
                // 입력 UI 스택뷰로 만들기
        let stack = UIStackView(arrangedSubviews: [
            titleField, contentTextView, pickImageButton, pickedImageView, saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    
    // 테이블 뷰 설정
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // 이미지 선택 버튼을 눌렀을 때
    @objc private func pickCardImageTapped() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.view.tag = 2002
        present(picker, animated: true)
    }
        
        // 다짐 저장 버튼을 눌렀을 때
    @objc private func saveTapped() {
        let titleText = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let contentText = (contentTextView.textColor == .secondaryLabel) ? "" : (contentTextView.text ?? "")
                
                // 제목/내용/이미지 중 아무 입력도 없으면 알림창을 띄운다.
        if titleText.isEmpty && contentText.isEmpty && pickedImageView.image == nil {
            let alert = UIAlertController(title: "입력 필요",
                                          message: "제목, 내용, 이미지 중 하나 이상 입력하세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
                
                // 새로운 '다짐' 생성 후 -> 배열에 추가
        let entry = Entry(
            title: titleText.isEmpty ? "무제" : titleText,
            content: contentText.isEmpty ? "내용 없음" : contentText,
            image: pickedImageView.image,
            createdAt: Date()
        )
        entries.insert(entry, at: 0)
        tableView.reloadData()
                
                // 입력 영역 전부 초기화
        titleField.text = nil
        contentTextView.text = "오늘의 학습 목표 또는 다짐을 적어보세요."
        contentTextView.textColor = .secondaryLabel
        pickedImageView.image = nil
    }
}

// 앨범에서 이미지 가져오기 처리
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self, let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                if picker.view.tag == 1001 {
                    self.backgroundImageView.image = image
                } else if picker.view.tag == 2002 {
                    self.pickedImageView.image = image
                }
            }
        }
    }
}

// 텍스트뷰 플레이스홀더 처리(기본 텍스트)
extension MainViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘의 학습 목표 또는 다짐 한마디를 적어보세요."
            textView.textColor = .secondaryLabel
        }
    }
}

// 테이블 뷰 데이터소스
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = UIListContentConfiguration.subtitleCell()
        content.text = entry.title
        content.secondaryText = entry.content
        content.secondaryTextProperties.numberOfLines = 0

        if let img = entry.image {
            content.image = img
            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
            content.imageProperties.cornerRadius = 8
        }

        cell.contentConfiguration = content
        cell.backgroundColor = .secondarySystemBackground
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true

        return cell
    }
}

