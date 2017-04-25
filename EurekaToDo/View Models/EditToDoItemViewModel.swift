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

extension EditToDoItemViewController {
  
  class ViewModel {
    
    private let toDo: ToDo
    
    var title: String? {
      get {
        return toDo.title
      }
      set {
        toDo.title = newValue
      }
    }
   
    var dueDate: Date {
      get {
        return toDo.dueDate
      }
      set {
        toDo.dueDate = newValue
      }
    }
    
    let reminderOptions: [String] = [ToDo.Reminder.none.rawValue,
                                     ToDo.Reminder.halfHour.rawValue,
                                     ToDo.Reminder.oneHour.rawValue,
                                     ToDo.Reminder.oneDay.rawValue,
                                     ToDo.Reminder.oneWeek.rawValue]
    var reminder: String? {
      get {
        return toDo.reminder.rawValue
      }
      set {
        if let value = newValue {
          toDo.reminder = ToDo.Reminder(rawValue: value)!
        }
      }
    }
 
    var image: UIImage? {
      get {
        if let data = toDo.image {
          return UIImage(data: data)
        }
        return nil
      }
      set {
        if let img = newValue {
          toDo.image = UIImagePNGRepresentation(img)
        } else {
          toDo.image = nil
        }
      }
    }
    
    let priorityOptions: [String] = [ToDo.Priority.low.rawValue,
                                     ToDo.Priority.medium.rawValue,
                                     ToDo.Priority.high.rawValue]
    
    var priority: String {
      get {
        return toDo.priority.rawValue
      }
      set {
        toDo.priority = ToDo.Priority(rawValue: newValue)!
      }
    }
    
    var categoryOptions: [String] = [ToDo.Category.home.rawValue,
                                     ToDo.Category.work.rawValue,
                                     ToDo.Category.personal.rawValue,
                                     ToDo.Category.play.rawValue,
                                     ToDo.Category.health.rawValue ]
    var category: String? {
      get {
        return toDo.category?.rawValue
      }
      set {
        if let value = newValue {
          toDo.category = ToDo.Category(rawValue: value)!
        }
      }
    }
    
    let repeatOptions: [String] = [ToDo.RepeatFrequency.never.rawValue,
                                   ToDo.RepeatFrequency.daily.rawValue,
                                   ToDo.RepeatFrequency.weekly.rawValue,
                                   ToDo.RepeatFrequency.monthly.rawValue,
                                   ToDo.RepeatFrequency.annually.rawValue]
    
    var repeatFrequency: String {
      get {
        return toDo.repeats.rawValue
      }
      set {
        toDo.repeats = ToDo.RepeatFrequency(rawValue: newValue)!
      }
    }
    
    // MARK: - Life Cycle
    
    init(toDo: ToDo) {
      self.toDo = toDo
    }
    
    // MARK: - Actions
    
    func delete() {
      NotificationCenter.default.post(name: .deleteToDoNotification, object: nil, userInfo: [ Notification.Name.deleteToDoNotification : toDo ])
    }
  }
}

extension Notification.Name {
  static let deleteToDoNotification = Notification.Name("delete todo")
}
