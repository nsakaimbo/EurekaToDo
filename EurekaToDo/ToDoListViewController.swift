/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ToDoListViewController: UIViewController {

  var viewModel: ViewModel!
  
  lazy var tableView: UITableView = {
    let tbl = UITableView()
    tbl.register(ToDoListTableViewCell.self, forCellReuseIdentifier: String(describing: ToDoListTableViewCell.self))
    tbl.dataSource = self
    tbl.delegate = self
    tbl.tableFooterView = UIView()
    return tbl
  }()
  
  // MARK: - Life Cycle
  
  convenience init(viewModel: ViewModel) {
    self.init()
    self.viewModel = viewModel
    initialize()
  }
  
  private func initialize() {
    // Add subviews
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    // Navigation items
    navigationItem.title = "My To-Dos"
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addButtonPressed)
    navigationItem.rightBarButtonItem = addButton
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // Actions
  @objc fileprivate func addButtonPressed(_ sender: UIBarButtonItem) {
    let addViewModel = viewModel.addViewModel()
    let addVC = EditToDoItemViewController(viewModel: addViewModel)
    navigationController?.pushViewController(addVC, animated: true)
  }
}

// MARK: - Selectors
extension Selector {
  fileprivate static let addButtonPressed = #selector(ToDoListViewController.addButtonPressed(_:))
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfToDos
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoListTableViewCell.self)) as! ToDoListTableViewCell
    cell.textLabel?.text = viewModel.title(at: indexPath.row)
    cell.detailTextLabel?.text = viewModel.dueDateText(at: indexPath.row)
    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let editViewModel = viewModel.editViewModel(at: indexPath.row)
    let editVC = EditToDoItemViewController(viewModel: editViewModel)
    navigationController?.pushViewController(editVC, animated: true)
  }
}
