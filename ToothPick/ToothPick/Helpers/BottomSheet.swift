//
//  BottomSheet.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation
import UIKit
import AFViewShaker

enum PostType {
    case edit
    case create
}
@objc open class BottomSheetHelper: NSObject {

    private static let shared = BottomSheetHelper()
    class func alterPost(viewController: UIViewController,
                        post: PostsModel? = nil,
                        type: PostType,
                        alter : ((_ post: PostsModel)->())?) {
        guard let vc = controller(viewController: viewController, post:post, type: type) else { return }
        vc.onAlterPost = { (post) in
            alter?(post)
        }
    }

    private class func controller(viewController: UIViewController,
                                  post: PostsModel? = nil,
                                  type: PostType) -> BottomSheet? {
        let dp = BottomSheet(post: post, type: type)
        dp.modalPresentationStyle = .overFullScreen
        dp.modalTransitionStyle = .crossDissolve
        viewController.present(dp, animated: true, completion: nil)
        return dp
    }
}

class BottomSheet: UIViewController {
    
    @IBOutlet weak var titleField: UITextField! {
        didSet {
            titleField.keyboardType = .default
            titleField.autocorrectionType = .no
            titleField.autocapitalizationType = .none
            titleField.returnKeyType = .next
            titleField.text = post?.title
            titleField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var descField: UITextField! {
        didSet {
            descField.keyboardType = .default
            descField.autocorrectionType = .no
            descField.autocapitalizationType = .none
            descField.returnKeyType = .go
            descField.text = post?.body
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var parentView: UIView! {
        didSet {
            parentView.layer.cornerRadius = 15
            parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    //MARK:- Public closuers
    var onAlterPost : ((_ post: PostsModel) -> Void)?
    var onWillDismiss : (() -> Void)?
    private var post: PostsModel?
    var PostType: PostType?
    
    var displayTxt: String {
        PostType == .create ? "Create" : "Edit Post"
    }
    //MARK:- Init
    init(post: PostsModel? = nil, type: PostType) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        self.PostType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if titleField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        titleLabel.text = displayTxt
        createButton.setTitle(displayTxt, for: .normal)
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
    }
    
    private func dismissVC() {
        onWillDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        dismissVC()
    }
    
    func handlePostConfig() -> PostsModel {
        let title = titleField.text ?? ""
        let body = descField.text ?? ""
        return PostsModel(userId: post?.userId ?? 0,
                          id: post?.id ?? 0,
                          title: title,
                          body: body)
    }
    
    private func handleShake<T: UIView>(view: T) {
        let shaker = AFViewShaker(view: view)
        shaker?.shake()
    }
    
    func validateInputs() -> Bool {
        guard !(titleField.text ?? "").isEmpty else {
            handleShake(view: titleField)
            return false
        }
        
        guard !(descField.text ?? "").isEmpty else {
            handleShake(view: descField)
            return false
        }
        return true
    }
    
    @IBAction func onDoneButton(sender : UIButton) {
        //Check and pass the Values
        if !validateInputs() { return }
        onAlterPost?(handlePostConfig())
        dismissVC()
    }
    
    @IBAction func onCancelButton(sender : UIButton) {
        dismissVC()
    }
}
