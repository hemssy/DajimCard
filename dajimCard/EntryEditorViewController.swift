import UIKit
import PhotosUI

final class EntryEditorViewController: UIViewController, PHPickerViewControllerDelegate, UITextViewDelegate {

    // 저장 시 메인으로 넘길 콜백
    var onSave: ((Entry) -> Void)?

    private let titleField = UITextField()
    private let contentTextView = UITextView()
    private let pickImageButton = UIButton(type: .system)
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "다짐 작성"

        // 취소(x), 저장
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장", style: .done, target: self, action: #selector(saveTapped))

        setupUI()
    }

    private func setupUI() {
        titleField.placeholder = "제목 입력"
        titleField.borderStyle = .roundedRect

        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.separator.cgColor
        contentTextView.layer.cornerRadius = 8
        contentTextView.text = "오늘의 학습 목표 또는 다짐을 적어보세요."
        contentTextView.textColor = .secondaryLabel
        contentTextView.delegate = self
        contentTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        pickImageButton.setTitle("이미지 선택", for: .normal)
        pickImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleField, contentTextView, pickImageButton, imageView])
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        let titleText = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let contentRaw = (contentTextView.textColor == .secondaryLabel) ? "" : (contentTextView.text ?? "")

        if titleText.isEmpty && contentRaw.isEmpty && imageView.image == nil {
            let alert = UIAlertController(title: "입력 필요", message: "제목, 내용, 이미지 중 하나 이상 입력하세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        let entry = Entry(
            title: titleText.isEmpty ? "무제" : titleText,
            content: contentRaw.isEmpty ? "내용 없음" : contentRaw,
            image: imageView.image,
            createdAt: Date()
        )
        onSave?(entry)          // 메인에 전달
        dismiss(animated: true) // 닫기
    }

    // MARK: - PHPicker
    @objc private func pickImage() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] obj, _ in
            guard let self = self, let img = obj as? UIImage else { return }
            DispatchQueue.main.async { self.imageView.image = img }
        }
    }

    // MARK: - Placeholder 처리
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘의 학습 목표 또는 다짐을 적어보세요."
            textView.textColor = .secondaryLabel
        }
    }
}

