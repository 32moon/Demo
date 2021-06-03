//
//  ViewController.swift
//  Demo_Alamofire
//
//  Created by 이문정 on 2021/06/03.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    //MARK:- Property
    let urlString = "https://api.androidhive.info/contacts/"
    let tableView = UITableView()
    var dataSource: [Contact] = []
    
    //MARK:- Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupUI()
        registerCell()
        fetchData()
    }
    
    private func fetchData() {
        // HTTP Request
        AF.request(urlString).responseJSON { (response) in
            switch response.result {
            // 성공
            case .success(let res):
                do {
                    // 반환 값을 Data타입으로 변환
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    // Data를 [Contact]타입으로 디코딩
                    let json = try JSONDecoder().decode(APIResponse.self, from: jsonData)
                    // dataSource에 디코딩한 값을 대입
                    self.dataSource = json.contacts
                    // 메인큐를 이용하여 tableView 리로딩
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                }
                // 실패
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func setupUI() {
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCell() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as! CustomCell
        cell.nameLabel.text = dataSource[indexPath.row].name
        cell.emailLabel.text = dataSource[indexPath.row].email
        cell.genderLabel.text = dataSource[indexPath.row].gender
        
        return cell
    }
}

