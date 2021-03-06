//
//  TagsTableViewCell.swift
//  TagListViewDemo
//
//  Created by arnaud on 23/11/16.
//  Copyright © 2016 Ela. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {
    
    var datasource: TagListViewDataSource? = nil {
        didSet {
            tagListView?.datasource = datasource
        }
    }
    
    var delegate: TagListViewDelegate? = nil {
        didSet {
            tagListView?.delegate = delegate
        }
    }

    var editMode = false {
        didSet {
            tagListView?.allowsRemoval = editMode
        }
    }
    
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.textFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            tagListView.alignment = .center
            tagListView.tagBackgroundColor = .green
            tagListView.cornerRadius = 10
            tagListView.delegate = delegate
            tagListView.datasource = datasource
            tagListView.allowsRemoval = editMode
        }
    }
}
