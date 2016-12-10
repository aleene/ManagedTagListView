//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

/// Delegate protocol for the TagView object.
public protocol TagViewDelegate: class {
    /// Returns when the tagView is tapped and the tagView that was tapped.
    func didTapTagView(_ tagView: TagView)
    /// Returns when the remove button of the tagView was tapped
    func didTapRemoveButton(_ tagView: TagView)
}

open class TagView: UIView {
    
    private struct Constants {
        static let RemoveButtonWidth: CGFloat = 24.0
    }
    
    /// TagView delegate gives access to the didTagView(_ tagView: TagView) method.
    public weak var delegate: TagViewDelegate?

    private var tapGestureRecognizer: UITapGestureRecognizer!

    /// TagView's title.
    public var title = "" {
        didSet {
            tagViewLabel?.text = title
            setupView()
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            background?.layer.cornerRadius = cornerRadius
            background?.layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            background?.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var paddingY: CGFloat = 2 {
        didSet {
            topLayoutConstraint?.constant = paddingY
            bottomLayOutConstraint?.constant = paddingY
            // titleEdgeInsets.top = paddingY
            // titleEdgeInsets.bottom = paddingY
        }
    }
    @IBInspectable open var paddingX: CGFloat = 5 {
        didSet {
            leadingLayOutConstraint?.constant = paddingX
            // titleEdgeInsets.left = paddingX
            //updateRightInsets()
        }
    }
    
    @IBInspectable open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            tagViewLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                // For highlighted, if it's nil, we should not fallback to backgroundColor.
                // Instead, we keep the current color.
                background?.backgroundColor = highlightedBackgroundColor
            }
        }
        else if isSelected {
            background?.backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            background?.layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            tagViewLabel?.textColor = UIColor.blue
            // setTitleColor(selectedTextColor, for: UIControlState())
        }
        else {
            background?.backgroundColor = tagBackgroundColor
            background?.layer.borderColor = borderColor?.cgColor
            tagViewLabel?.textColor = UIColor.white
            // setTitleColor(textColor, for: UIControlState())
        }
    }
    
    open var isHighlighted: Bool = false {
        didSet {
            reloadStyles()
        }
    }
    
    open var isSelected: Bool = false {
        didSet {
            reloadStyles()
        }
    }
    
    /// function that responds to the Token's tapGestureRecognizer.
    func didTapTagView(_ sender: UITapGestureRecognizer) {
        delegate?.didTapTagView(self)
    }

    // MARK: remove button
    
    open var removeButtonIsEnabled = false {
        didSet {
            if removeButtonIsEnabled {
                removeButtonWidthConstraint.constant = Constants.RemoveButtonWidth
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TagView.removeButtonTapped(_:)))
                removeButton.addGestureRecognizer(tapGestureRecognizer)

            } else {
                removeButtonWidthConstraint.constant = 0
            }
            removeButton.isEnabled = removeButtonIsEnabled
            // updateRightInsets()
        }
    }
    
    /*
     
    @IBInspectable open var removeButtonIconSize: CGFloat = 12 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }
    @IBInspectable open var removeIconLineWidth: CGFloat = 3 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    @IBInspectable open var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }
    */
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    // open var onLongPress: ((TagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        self.title = title
        super.init(frame: CGRect.zero)
        loadView()
        setupView()
    }
    
    private func setupView() {
        frame.size = intrinsicContentSize

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TagView.didTapTagView(_:)))
        addGestureRecognizer(tapGestureRecognizer)

    }
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        /// Returns the intrinsicContentSize. The preferred size of the view.
        var size = tagViewLabel?.intrinsicContentSize
        size?.height = textFont.pointSize + paddingY * 2
        size?.width += paddingX * 2
        if removeButtonIsEnabled {
            size?.width += Constants.RemoveButtonWidth // + paddingX
        }

        return size != nil ? size! : CGSize.init(width: 20, height: 5)
    }
    
    private func updateRightInsets() {
        if removeButtonIsEnabled {
            trailingLayOutConstraint?.constant = paddingX  + Constants.RemoveButtonWidth // + paddingX
            // titleEdgeInsets.right = paddingX  + removeButtonIconSize + paddingX
        }
        else {
            //titleEdgeInsets.right = paddingX
            trailingLayOutConstraint?.constant = paddingX
        }
    }
    
    @IBOutlet weak var tagViewLabel: UILabel! {
        didSet {
            tagViewLabel.text = title
            tagViewLabel.textAlignment = .left
        }
    }
    
    @IBOutlet weak var bottomLayOutConstraint: NSLayoutConstraint! {
        didSet {
            bottomLayOutConstraint.constant = paddingY
        }
    }
    @IBOutlet weak var leadingLayOutConstraint: NSLayoutConstraint! {
        didSet {
            leadingLayOutConstraint.constant = paddingX
        }
    }
    @IBOutlet weak var trailingLayOutConstraint: NSLayoutConstraint! {
        didSet {
            updateRightInsets()
        }
    }
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint! {
        didSet {
            topLayoutConstraint.constant = paddingY
        }
    }
    
    @IBOutlet weak var background: UIView! {
        didSet {
            
        }
    }
    @IBOutlet weak var removeButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        delegate?.didTapRemoveButton(self)
    }
    
    private func loadView() {
        let type = type(of: self)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: String(describing: type), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

    }
}

