//
//  ViewController.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 19.05.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel = TestViewModel()

    private let tableView = UITableView()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: viewModel.cellIdentifier,
            for: indexPath
        )

        cell.imageView?.image = nil

        if let url = viewModel.url(withRowIndex: indexPath.row) {

            downloadImage(withURL: url, forCell: cell)
        }

        return cell
    }


    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {

        if let image = viewModel.cache[url] {
            cell.imageView?.image = image
            return
        }

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in

            if let data = try? Data(contentsOf: url) {

                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.viewModel.cache[url] = image
                    cell.imageView?.image = image

                    if let ip = self?.tableView.indexPath(for: cell) {
                        self?.tableView.reloadRows(at: [ip], with: .fade)
                    }
                }
            }
        }
    }
}

class TestViewModel {
    let numberOfRow = 100
    let cellIdentifier = "CellIdentifier"

    fileprivate(set) var cache = [URL: UIImage]()

    func url(withRowIndex index: Int) -> URL? {
        URL(string: "http://placehold.it/375x150?text=\(index + 1)")
    }
}
