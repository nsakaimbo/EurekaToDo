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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let oneDay = DateComponents(day:1)
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: oneDay, to: today)!
    let toDo = ToDo(title: "Walk the dog",
                    dueDate: tomorrow,
                    priority: ToDo.Priority.medium.rawValue,
                    reminderDate: today,
                    category: ToDo.Category.play.rawValue,
                    repeats: ToDo.RepeatFrequency.daily.rawValue,
                    image: nil)
    let viewModel = ToDoListViewController.ViewModel(toDos: [toDo])
    let listViewController = ToDoListViewController(viewModel: viewModel)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController(rootViewController: listViewController)
    window?.backgroundColor = .black
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 237.0/255, green: 76/255, blue: 119/255, alpha: 1)
    UINavigationBar.appearance().isTranslucent = false
    let navigationTitleAttributes: [String: Any] = {
      return [ NSForegroundColorAttributeName: UIColor.white ]
    }()
    UINavigationBar.appearance().tintColor = .white
    UIBarButtonItem.appearance().setTitleTextAttributes(navigationTitleAttributes, for: .normal)
    UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
    
    return true
  }
}

