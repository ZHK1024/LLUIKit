//
//  LLSMSCodeViewController.swift
//  LLSMSCodeViewController
//
//  Created by Ruris on 01/20/2021.
//  Copyright (c) 2021 Ruris. All rights reserved.
//

import UIKit
import SnapKit

open class LLSMSCodeViewController: UIViewController, LLSMSCodeInputViewDelegate {
    
    /// SMSCode 长度
    open var smsCodeLenght: Int { 4 }
    
    /// 重发时长
    open var deadline: Int { 60 }
    
    /// 重发倒计时剩余时间
    private lazy var timeLeft: Int = deadline
    
    /// 标题
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 29.0)
        label.text = "输入验证码"
        return label
    }()
    
    /// 提示语
    public let tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .darkGray
        return label
    }()
    
    /// 验证码输入视图
    private lazy var smsCodeView = LLSMSCodeInputView(length: smsCodeLenght)
    
    /// 重发倒计时计时器
    private lazy var resendTimer: Timer = {
        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] (timer) in
            self?.countDown(timer: timer)
        }
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    /// 发送按钮
    public lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(requestSMSCode), for: .touchUpInside)
        return button
    }()
    
    /// 手机号码
    open var mobile: String? {
        didSet {
            if mobile == nil {
                tipsLabel.text = ""
            } else {
                tipsLabel.text = "验证码已发送至 +86 \(mobile!)"
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        smsCodeView.showCursor()
    }
    
    // MARK: UI
    func setupUI() {
        title = "输入验证码"
        view.addSubview(titleLabel)
        view.addSubview(tipsLabel)
        view.addSubview(smsCodeView)
        view.addSubview(sendButton)
        
        smsCodeView.delegate = self
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(40.0)
            $0.top.equalTo(55.0)
            $0.right.equalTo(-40.0)
        }
        
        tipsLabel.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(14.0)
        }
        
        smsCodeView.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(tipsLabel.snp.bottom).offset(30.0)
            $0.height.equalTo(smsCodeView.snp.width).multipliedBy(150.0 / 1000.0)
        }
        
        sendButton.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.height.equalTo(45.0)
            $0.width.greaterThanOrEqualTo(180.0)
            $0.top.equalTo(smsCodeView.snp.bottom).offset(45.0)
        }
        
        sendButton.isHidden = true
    }

    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        titleLabel.snp.updateConstraints {
            $0.top.equalTo(40.0 + view.safeAreaInsets.top)
        }
    }
    
    // MARK: 重发相关
    
    /// 开始倒计时
    open func fire() {
        sendButton.isHidden = false
        resendTimer.fireDate = Date()
    }
    
    /// 暂停倒计时
    open func pause() {
        resendTimer.fireDate = Date.distantFuture
    }
    
    @objc func countDown(timer: Timer) {
        timeLeft -= 1
        if timeLeft > 0 {
            sendButton.setTitle("\(timeLeft)秒后获取验证码", for: .normal)
            sendButton.isEnabled = false
        } else {
            pause()
            timeLeft = deadline
            sendButton.setTitle("重新获取验证码", for: .normal)
            sendButton.isEnabled = true
        }
    }
    
    // MARK: Send
    
    /// 获取验证码
    @objc func requestSMSCode() {
        fire()
    }
    
    // MARK: LLSMSCodeInputViewDelegate
    
    open func didSMSCodeChanged(code: String) {
        print(code)
    }
}
