//
//  ViewController.swift
//  SearchName
//
//  Created by quynhlx on 2019/11/03.
//  Copyright © 2019 quynhlx. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var searchTextFiled: UITextField!
    var userModelView = UserViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        userTable.estimatedRowHeight = 800
        userTable.rowHeight = UITableView.automaticDimension
        bindUI()
    }

    private func bindUI() {
        self.searchTextFiled.rx.text.throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance).distinctUntilChanged().asObservable().bind(to: self.userModelView.searchInput).disposed(by: disposeBag)
        self.userModelView.searchResult.asObservable().bind(to: self.userTable.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) {(index, user, cell) in
            cell.idLabel.text = String(user.id)
            cell.userNameLabel.text = user.userName
        }.disposed(by: disposeBag)
    }

}
