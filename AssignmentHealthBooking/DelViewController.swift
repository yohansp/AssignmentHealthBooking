//
//  DelViewController.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import UIKit
import RxSwift

class DelViewController: UIViewController {
    
    private var _disposeBag: DisposeBag?
    var disposeBag: DisposeBag {
        get {
            if let d = self._disposeBag {
                return d
            } else {
                self._disposeBag = DisposeBag()
                return self._disposeBag!
            }
        }
    }
    
    lazy var viewWait: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 19
        return view
    }()
    
    lazy var wait: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    var alert: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func setupToolbar(_ title: String) {
        navigationItem.title = title
    }
    
    func showWait() {
        view.addSubview(viewWait)
        viewWait.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        viewWait.addSubview(wait)
        wait.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
        wait.startAnimating()
    }
    
    func hideWait() {
        wait.stopAnimating()
        wait.removeFromSuperview()
        viewWait.removeFromSuperview()
    }
    
    func showAlert(_ title: String = "Info", message: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert!, animated: true)
    }
}
