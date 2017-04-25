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

import Foundation

extension ToDoListViewController {
  
  class ViewModel {
    
    private var toDos: [ToDo]
    private lazy var dateFormatter: DateFormatter = {
      let fmtr = DateFormatter()
      fmtr.dateFormat = "EEEE, MMM d"
      return fmtr
    }()
    
    var numberOfToDos: Int {
      return toDos.count
    }
   
    private func toDo(at index: Int) -> ToDo {
      return toDos[index]
    }
    
    func title(at index: Int) -> String {
      return toDo(at: index).title ?? ""
    }
    
    func dueDateText(at index: Int) -> String {
      let date = toDo(at: index).dueDate
      return dateFormatter.string(from: date)
    }
   
    func editViewModel(at index: Int) -> EditToDoItemViewController.ViewModel {
      let toDo = self.toDo(at: index)
      let editViewModel = EditToDoItemViewController.ViewModel(toDo: toDo)
      return editViewModel
    }
    
    func addViewModel() -> EditToDoItemViewController.ViewModel {
      let toDo = ToDo()
      toDos.append(toDo)
      let addViewModel = EditToDoItemViewController.ViewModel(toDo: toDo)
      return addViewModel
    }
    
    @objc private func removeToDo(_ notification: Notification) {
      guard let userInfo = notification.userInfo,
        let toDo = userInfo[Notification.Name.deleteToDoNotification] as? ToDo,
        let index = toDos.index(of: toDo) else {
          return
      }
      toDos.remove(at: index)
    }
    
    // MARK: Life Cycle
    init(toDos: [ToDo] = []) {
      self.toDos = toDos
      
      NotificationCenter.default.addObserver(self, selector: #selector(removeToDo(_:)), name: .deleteToDoNotification, object: nil)
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
  }
}
