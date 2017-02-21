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
    
    var searchField: UITextField!
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
        
        self.searchField = UITextField(frame: CGRect.zero)
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        self.searchField.borderStyle = UITextBorderStyle.none
        self.searchField.backgroundColor = UIColor.white
        self.searchField.autocorrectionType = UITextAutocorrectionType.no
        self.searchField.keyboardType = UIKeyboardType.default
        self.searchField.returnKeyType = UIReturnKeyType.done
        self.searchField.clearButtonMode = UITextFieldViewMode.whileEditing
        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        self.searchField.target(forAction: Selector(("textFieldDidChange:")), withSender: self)
        self.searchField.delegate = self
        
        self.tableDataSource = GMSAutocompleteTableDataSource()
        self.tableDataSource.delegate = self
        
        self.resultsController = UITableViewController(style: UITableViewStyle.plain)
        self.resultsController.tableView.delegate = self.tableDataSource
        self.resultsController.tableView.dataSource = self.tableDataSource

        self.view.addSubview(self.searchField)
        
        let searchFieldView = ["searchFieldView" : self.searchField]
        let searchFieldConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[_searchField]-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: searchFieldView)
        
        self.view.addConstraints(searchFieldConstraint)
        
        let searchFieldConstraintBottom = NSLayoutConstraint(item: self.searchField,
                                                             attribute: NSLayoutAttribute.top,
                                                             relatedBy: NSLayoutRelation.equal,
                                                             toItem: self.topLayoutGuide,
                                                             attribute: NSLayoutAttribute.bottom,
                                                             multiplier: 1,
                                                             constant: 8)
        self.view.addConstraint(searchFieldConstraintBottom)
        
        self.addResultViewBelow(view: self.searchField)
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
        self.resultsController.view.translatesAutoresizingMaskIntoConstraints = false
        self.resultsController.view.alpha = CGFloat(0)
        self.view.addSubview(self.resultsController.view)
        
        //layout it out below the textfield using autolayout
        
//        var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
//        viewBindingsDict.setValue(fooView, forKey: "fooView")
//        viewBindingsDict.setValue(barView, forKey: "barView")
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[fooView]-[barView]-|", options: nil, metrics: nil, views: viewBindingsDict))
    
        
        var bothViews: NSMutableDictionary = NSMutableDictionary()
        bothViews.setValue(self.searchField, forKey: "aSearchFieldView")
        bothViews.setValue(self.resultsController.view, forKey: "aResultView")
        let aConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[_searchField]-[resultView]-(0)-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: bothViews
                                                        )
        self.view.addConstraints(aConstraint)
        
        let anotherResultView = ["anotherResultView" : self.resultsController.view]
        let anotherConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[resultView]-(0)-|",
                                                               options: NSLayoutFormatOptions(rawValue: 0),
                                                               metrics: nil,
                                                               views: anotherResultView)
        self.view.addConstraints(anotherConstraint)
        
        //do a force layout
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

