//
//  RestaurantInfoViewController.swift
//  Eat
//
//  Created by Henry Jones on 2018-03-09.
//  Copyright © 2018 launchpad. All rights reserved.
//

import Foundation
import UIKit

class RestaurantInfoViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var exitButton: UIButton!

  static func viewController(restaurant: Restaurant) -> RestaurantInfoViewController {
    let storyboard = UIStoryboard(name: "RestaurantInfoScreen", bundle: nil)
    guard let restaurantVC = storyboard.instantiateViewController(withIdentifier: "RestaurantInfoVC") as? RestaurantInfoViewController
      else { fatalError() }
    restaurantVC.myRestaurant = restaurant
    return restaurantVC
  }

  var myRestaurant = Restaurant(name: "", rating: 0, phone: "", status: false, imageUrl: "", address: "", foodType: "", reviewCount: 0, distance: 0.0, id: "", yelpUrl: "")
  let dataManager = DataManager.default
  var reviews: [Review] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .singleLine
    tableView.allowsSelection = false
    self.getReviews()
    self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
  }

  @IBAction func exitButtonPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  func getReviews(){
    dataManager.fetchReviews(with: myRestaurant.id)
      .onSuccess { rev in
        self.reviews = rev
        self.tableView.reloadSections(IndexSet(integer: Section.reviews.rawValue), with: .none)
      }.onFailure { error in
        print(error)
    }
  }
}

extension RestaurantInfoViewController: UITableViewDataSource {

  enum Section: Int {
    case photo, title, InfoMenu, InfoAddress, reviews

    static let count = 5
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
    switch section {
    case .photo:
      guard let cell =
        tableView.dequeueReusableCell(withIdentifier: "RestaurantPhotoCell", for: indexPath) as? RestaurantPhotoCell else { fatalError() }
      cell.configure(imageUrl: myRestaurant.imageUrl)
      return cell
    case .title:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTitleCell",for: indexPath) as? RestaurantTitleCell else { fatalError() }
      cell.configure(restaurant: myRestaurant)
      return cell
    case .InfoMenu:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoCell",for: indexPath) as? RestaurantInfoCell else { fatalError() }
      return cell
    case .InfoAddress:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoAddressCell",for: indexPath) as? RestaurantInfoAddressCell else { fatalError() }
      cell.configure(restaurant: myRestaurant)
      return cell
    case .reviews:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantReviewCell",for: indexPath) as? RestaurantReviewCell else { fatalError() }
      print(indexPath.row)
      cell.configure(review: reviews[indexPath.row])
      return cell
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let section = Section(rawValue: section) else { fatalError() }
    switch section {
    case .photo:
      return ""
    case .title:
      return ""
    case .InfoMenu:
      return "INFO"
    case .InfoAddress:
      return ""
    case .reviews:
      return "REVIEWS"
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else { fatalError() }
    switch section {
    case .photo:
      return 1
    case .title:
      return 1
    case .InfoMenu:
      return 1
    case .InfoAddress:
      return 1
    case .reviews:
      return reviews.count
    }
  }

}

extension RestaurantInfoViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
    switch section {
    case .photo:
      return 267
    case .title:
      return 160
    case .InfoMenu:
      return 65
    case .InfoAddress:
      return 65
    case .reviews:
      return 150
    }
  }
}

