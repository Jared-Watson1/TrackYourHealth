//
//  ViewController.swift
//  TrackYourHealth
//
//  Created by Jared Watson on 1/7/22.
//

import WidgetKit
import UIKit

class ViewController: UIViewController {
    
    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter text"
        field.backgroundColor = .white
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(field)
        view.addSubview(button)
        field.becomeFirstResponder()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        field.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.frame.size.width - 40, height: 52)
        
        button.frame = CGRect(x: 30, y: view.safeAreaInsets.top + 70, width: view.frame.size.width - 60, height: 50)
    }
    
    @objc private func didTapButton() {
        field.resignFirstResponder()
        
        let userDefaults = UserDefaults(suiteName: "group.widgetcache")
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        userDefaults?.setValue(text, forKey: "text")
        WidgetCenter.shared.reloadAllTimelines() // app tells iOS to refresh widget
    }


}

