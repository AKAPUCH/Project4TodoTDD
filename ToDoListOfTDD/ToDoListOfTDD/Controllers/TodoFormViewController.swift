
import UIKit
import SnapKit
class TodoFormViewController: UIViewController {
    
    var datePicker = UIDatePicker()
    var itemManager : ModelManager?
    lazy var cancelButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(discardForm), for: .touchUpInside)
        return button
    }()
    lazy var submitButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        return button
    }()
    var pickerLabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textAlignment = .center
        return label
    }()
    lazy var titleTextField = textField
    lazy var locationTextField = textField
    lazy var descriptionTextField = textField
    lazy var buttonStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton,submitButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    var textField : UITextField {
        return {
            let textField = UITextField()
            textField.font = .systemFont(ofSize: 24)
            textField.textAlignment = .left
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.clearsOnBeginEditing = false
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 1
            textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return textField
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        [titleTextField,locationTextField,descriptionTextField].forEach{$0.resignFirstResponder()}
    }
    
    func setUI() {
        setTextField()
        setDatePicker()
        setButton()
    }
    
    func setTextField() {
        titleTextField.placeholder = " 할일 명"
        locationTextField.placeholder = " 장소"
        descriptionTextField.placeholder = " 상세 설명"
        titleTextField.becomeFirstResponder()
        [titleTextField,locationTextField,descriptionTextField].forEach{view.addSubview($0)}
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.width.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.top).offset(50)
            make.width.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(locationTextField.snp.top).offset(50)
            make.width.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(checkForm), for: .valueChanged)
        view.addSubview(datePicker)
        view.addSubview(pickerLabel)
        pickerLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.top).offset(50)
            make.width.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(pickerLabel.snp.bottom).offset(5)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setButton() {
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(50)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func createItem(title : String, description : String, date : Date, location : String) {
        
        let newItem = TodoItem(title: title, description: description, rawDate: date, todoLocation: Location(name: location))
        itemManager?.addItem(newItem)
    }
    
    @objc func discardForm() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func submitForm() {
        guard let title = titleTextField.text,let location = locationTextField.text,let detail = descriptionTextField.text else {return}
        createItem(title: title, description: description, date: datePicker.date, location: location)
        navigationController?.popViewController(animated: false)
    }
    
    @objc func checkForm() {
        guard let title = titleTextField.text,let location = locationTextField.text,let detail = descriptionTextField.text else {return}
        if title.count > 0 && location.count > 0 && detail.count > 0 {
            submitButton.isEnabled = true
        }
    }
    

    
    

}

extension TodoFormViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
