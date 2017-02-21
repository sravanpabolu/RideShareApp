//
//  GooglePlacesViewController.swift
//  RideShareApp
//
//  Created by TCS on 21/02/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import UIKit
import GooglePlaces

class GooglePlacesViewController: BaseViewController, GMSAutocompleteTableDataSourceDelegate, UITextFieldDelegate {
    
    @IBOutlet var searchField: UITextField!
    var tableDataSource: GMSAutocompleteTableDataSource!
    var resultsController: UITableViewController!
    
//    override init() {
//        super.init()
//        print("Hello")
//    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField?.target(forAction: Selector(("textFieldDidChange:")), withSender: self)
        self.searchField?.delegate = self
        
        self.tableDataSource = GMSAutocompleteTableDataSource()
        self.tableDataSource.delegate = self
        
        self.resultsController = UITableViewController(style: UITableViewStyle.plain)
        self.resultsController.tableView.delegate = self.tableDataSource
        self.resultsController.tableView.dataSource = self.tableDataSource
//        self.resultsController.tableView.frame = CGRect(x: 0, y: 50, width: self.resultsController.view.frame.size.width, height: self.resultsController.view.frame.size.height - 50)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper Methods
    func addResultViewBelow(view: UIView) {
        
    }
    
    func autoCompleteDidSelectPlace(place: GMSPlace) {
        var text:NSMutableAttributedString = NSMutableAttributedString(string: place.description)
        if (place.attributions != nil) {
            text.append(NSAttributedString(string: "\n\n"))
            text.append(place.attributions!)
        }
        self.searchField.attributedText = text
//        self.searchField.text = place.name
    }
    
    func textFieldDidChange(textField: UITextField) {
        self.tableDataSource.sourceTextHasChanged(textField.text)
    }
    
    //MARK: GMSAutoCompleteTableDataSourceDelegate methods
    public func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace){
        
        self.searchField.resignFirstResponder()
        self.autoCompleteDidSelectPlace(place: place)
        self.searchField.text = place.name
    }
    
    public func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        
        self.searchField.resignFirstResponder()
        self.searchField.text = "Some Error"
    }
    
    //MARK: GMSAutoCompleteTableDataSourceDataSource methods
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.resultsController.tableView.reloadData()
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.resultsController.tableView.reloadData()
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addChildViewController(self.resultsController)
        
        //add the results controller
        self.resultsController.view.alpha = CGFloat(0)
        
        self.view.addSubview(self.resultsController.view)
        
        self.view.layoutIfNeeded()
        
        self.resultsController.tableView.reloadData()
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.resultsController.view.alpha = CGFloat(1.0)
        }) { (finished:Bool) in
            self.resultsController.didMove(toParentViewController: self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //dismiss the results
        self.resultsController.willMove(toParentViewController: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.resultsController.view.alpha = CGFloat(0.0)
        }) { (finished:Bool) in
            self.resultsController.view.removeFromSuperview()
            self.resultsController.removeFromParentViewController()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
        return false
    }
}

