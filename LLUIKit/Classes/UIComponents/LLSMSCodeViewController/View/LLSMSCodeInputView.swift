//
//  LLSMSCodeInputView.swift
//  LLSMSCodeViewController
//
//  Created by ZHK on 2021/1/20.
//  
//

import UIKit

public protocol LLSMSCodeInputViewDelegate: NSObject {
    
    /// 输入的验证码发生改变
    /// - Parameter code: 验证码内容
    func didSMSCodeChanged(code: String)
}

class LLSMSCodeInputView: UIView {
    
    /// 代理
    public weak var delegate: LLSMSCodeInputViewDelegate?
    
    /// 输入内容长度
    private let length: Int
    
    /// 输入内容展示视图
    private lazy var itemViews: [LLSMSCodeItemView] = {
        (0..<length).map { _ in LLSMSCodeItemView() }
    }()
    
    /// 布局视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: itemViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    /// 文本输入控件
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        if #available(iOS 12.0, *) {
            textField.textContentType = .oneTimeCode
        }
        return textField
    }()
    
    /// 光标
    private let cursorLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        return layer
    }()
    
    /// 光标闪烁计时 timer
    private lazy var cursorTimer: Timer = {
        let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] (_) in
            self?.cursorLayer.isHidden.toggle()
        }
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    override var backgroundColor: UIColor? {
        didSet {
            stackView.backgroundColor = backgroundColor
            textField.backgroundColor = backgroundColor
            textField.textColor = backgroundColor
            textField.tintColor = backgroundColor
        }
    }
    
    ///  谓词, 用于匹配输入结果是否是纯数字
    private let numeralPredicate = NSPredicate(format: "SELF MATCHES %@", "^\\d*$")
    
    // MARK: Init & Deinit
    
    init(length: Int) {
        self.length = length
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cursorTimer.invalidate()
    }
    
    // MARK:
    
    /// 显示光标 (开始输入)
    func showCursor() {
        textField.becomeFirstResponder()
        cursorTimer.fireDate = Date()
    }
    
    // MARK: UI
    
    func setupUI() {
        backgroundColor = .white
        addSubview(textField)
        addSubview(stackView)
        layer.addSublayer(cursorLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if length == 0 { return }
        stackView.frame = bounds
        stackView.spacing = (bounds.width / CGFloat(length)) * 0.5
        textField.frame = bounds;

        layoutCursor(len: textField.text?.count ?? 0)
    }
    
    /// 更新 光标 位置
    /// - Parameter len: 当前输入文本的长度
    func layoutCursor(len: Int) {
        cursorLayer.frame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: bounds.height / 2)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if len < itemViews.count {
            cursorLayer.opacity = 1.0
            cursorLayer.position = itemViews[len].center
        } else {
            cursorLayer.opacity = 0.0
        }
        CATransaction.commit()
    }
    
    @objc func textChanged(textField: UITextField) {
        /// 重置 item 中文本内容
        itemViews.forEach { $0.textLabel.text = "" }
        guard let text = textField.text else { return }
        /// text 分为单个字符
        let subStrings = Array(text)
        /// 填充 item 中文本内容
        for index in 0..<subStrings.count {
            itemViews[index].textLabel.text = String(subStrings[index])
        }
        layoutCursor(len: text.count)
        delegate?.didSMSCodeChanged(code: text)
    }
}

extension LLSMSCodeInputView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return string.count > length
        }
        let resultText = (text as NSString).replacingCharacters(in: range, with: string)
        /// 只能输入数字, 且长度在限定长度以内
        return numeralPredicate.evaluate(with: resultText) && resultText.count <= length
    }
}

fileprivate class LLSMSCodeItemView: UIView {
    
    /// 底部下划线
    let lineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        return layer
    }()
    
    /// 文本视图
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(textLabel)
        layer.addSublayer(lineLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height - 1.0)
        lineLayer.frame = CGRect(x: 0.0, y: bounds.maxY - 1, width: bounds.width, height: 1.0)
    }
}
