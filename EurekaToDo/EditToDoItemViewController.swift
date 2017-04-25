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

import Eureka
import UIKit
import ImageRow

class EditToDoItemViewController: FormViewController {
  
  var viewModel: ViewModel!
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d yyyy, h:mm a"
    return formatter
  }()
  
  let categorySectionTag: String = "add category section"
  let categoryRowTag: String = "add category row"
  
  lazy var footerTapped: EditToDoTableFooter.TappedClosure = { [weak self] footer in //1
    
    guard let form = self?.form,
      let sectionTag = self?.categorySectionTag,
      let section = form.sectionBy(tag: sectionTag) else {
        return
    }
    
    footer.removeFromSuperview()
    
    section.hidden = false
    section.evaluateHidden()
    
    if let rowTag = self?.categoryRowTag,
      let row = form.rowBy(tag: rowTag) as? ToDoCategoryRow {
      let category = self?.viewModel.categoryOptions[0]
      self?.viewModel.category = category
      row.value = category
      row.cell.update()
    }
  }
  
  // MARK: - Life Cycle
  convenience init(viewModel: ViewModel) {
    self.init()
    self.viewModel = viewModel
    initialize()
  }
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form
      +++ Section()
      <<< TextRow() {
        $0.title = "Description"
        $0.placeholder = "e.g. Pick up my laundry"
        $0.value = viewModel.title
        $0.onChange { [unowned self] row in
          self.viewModel.title = row.value
        }
        $0.add(rule: RuleRequired()) //1
        $0.validationOptions = .validatesOnChange //2
        $0.cellUpdate { (cell, row) in //3
          if !row.isValid {
            cell.titleLabel?.textColor = .red
          }
        }
    }
    
      +++ Section()
      <<< DateTimeRow() {
        $0.dateFormatter = type(of: self).dateFormatter //1
        $0.title = "Due date" //2
        $0.value = viewModel.dueDate //3
        $0.minimumDate = Date() //4
        $0.onChange { [unowned self] row in //5
          if let date = row.value {
            self.viewModel.dueDate = date
          }
        }
    }

      <<< PushRow<String>() { //1
        $0.title = "Repeats" //2
        $0.value = viewModel.repeatFrequency //3
        $0.options = viewModel.repeatOptions //4
        $0.onChange { [unowned self] row in //5
          if let value = row.value {
            self.viewModel.repeatFrequency = value
          }
        }
    }

      +++ Section()
      <<< SegmentedRow<String>() {
        $0.title = "Priority"
        $0.value = viewModel.priority
        $0.options = viewModel.priorityOptions
        $0.onChange { [unowned self] row in
          if let value = row.value {
            self.viewModel.priority = value
          }
        }
    }

      <<< AlertRow<String>() {
        $0.title = "Reminder"
        $0.selectorTitle = "Remind me"
        $0.value = viewModel.reminder
        $0.options = viewModel.reminderOptions
        $0.onChange { [unowned self] row in
          if let value = row.value {
            self.viewModel.reminder = value
          }
        }
    }

      +++ Section("Picture Attachment")
      <<< ImageRow() {
        $0.title = "Attachment"
        $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
        $0.value = viewModel.image //2
        $0.clearAction = .yes(style: .destructive) //3
        $0.onChange { [unowned self] row in //4
          self.viewModel.image = row.value
        }
    }
    
      +++ Section("Category") {
        $0.tag = self.categorySectionTag
        $0.hidden = (self.viewModel.category != nil) ? false : true
      }
      
      <<< ToDoCategoryRow() { row in
        row.tag = self.categoryRowTag
        row.value = self.viewModel.category
        row.options = self.viewModel.categoryOptions

        row.onChange { [unowned self] row in
          self.viewModel.category = row.value
        }
    }
    
    let footer = EditToDoTableFooter(frame: .zero)
    footer.action = footerTapped

    if let tableView = tableView, viewModel.category == nil {
      tableView.tableFooterView = footer
      tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50.0)
    }
  }
  
  private func initialize() {
    let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: .deleteButtonPressed)
    navigationItem.leftBarButtonItem = deleteButton
    
    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .saveButtonPressed)
    navigationItem.rightBarButtonItem = saveButton
    
    view.backgroundColor = .white
  }
  
  // MARK: - Actions
  @objc fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
    if form.validate().isEmpty {
      _ = navigationController?.popViewController(animated: true)
    }
  }
  
  @objc fileprivate func deleteButtonPressed(_ sender: UIBarButtonItem) {
   
    let alert = UIAlertController(title: "Delete this item?", message: nil, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
      self?.viewModel.delete()
      _ = self?.navigationController?.popViewController(animated: true)
    }
    
    alert.addAction(delete)
    alert.addAction(cancel)
    
    navigationController?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Selectors
extension Selector {
  fileprivate static let saveButtonPressed = #selector(EditToDoItemViewController.saveButtonPressed(_:))
  fileprivate static let deleteButtonPressed = #selector(EditToDoItemViewController.deleteButtonPressed(_:))
}
