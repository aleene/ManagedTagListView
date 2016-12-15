//
//  TagListView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

// MARK: - TagListView Delegate Functions

@objc public protocol TagListViewDelegate {
    // @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    // @objc optional func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, didSelectTagAt index: Int) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, willSelectTagAt index: Int) -> Int
    @objc optional func tagListView(_ tagListView: TagListView, didDeselectTagAt index: Int) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, willDeselectTagAt index: Int) -> Int
    @objc optional func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int)
    @objc optional func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int)
    @objc optional func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int,
                            toProposed proposedDestinationIndex: Int) -> Int
    @objc optional func tagListView(_ tagListView: TagListView, didAddTagWith title: String)
    @objc optional func tagListView(_ tagListView: TagListView, willDisplay: TagView) -> TagView
    
    /// Called when the user returns for a given input.
    ///func tagListView(_ tagListView: TagListView, didEnter text: String)
    /// Called when the user tries to delete a tag at the given index.
    @objc optional func tagListView(_ tagListView: TagListView, didDeleteTagAt index: Int)

    /// Called when the user changes the text in the textField.
    ///func tagListView(_ tagListView: TagListView, didChange text: String)
    /// Called when the TagListView did begin editing.
    ///func tagListViewDidBeginEditing(_ tagListView: TagListView)
    /// Called when the TagListView's content height changes.
    ///func tagListView(_ tagListView: TagListView, didChangeContent height: CGFloat)
}

// MARK: - TagListView DataSource Functions

@objc public protocol TagListViewDataSource {
    /// Is it allowed to edit a Tag object at a given index?
    @objc optional func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool
    /// Is it allowed to move a Tag object at a given index?
    @objc optional func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool
    /// The Tag object at the source index has been moved to a destination index.
    @objc optional func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int)
    /// What is the title for the Tag object at a given index?
    func tagListView(_ tagListView: TagListView, titleForTagAt index: Int) -> String
    /// What are the number of Tag objects in the TagListView?
    func numberOfTagsIn(_ tagListView: TagListView) -> Int
    /// Caled if the user wants to delete all tags
    @objc optional func didClear(_ tagListView: TagListView)

    /// Which text should be displayed when the TagListView is collapsed?
    @objc optional func tagListViewCollapsedText(_ tagListView: TagListView) -> String
}

// MARK: - TagListView CLASS

@IBDesignable
open class TagListView: UIView, TagViewDelegate, BackspaceTextViewDelegate, UITextViewDelegate {
    
    @IBOutlet open weak var delegate: TagListViewDelegate?
    @IBOutlet open weak var datasource: TagListViewDataSource? {
        didSet {
            reloadData()
        }
    }

    //MARK: - Default values
    
    private struct Constants {
        /// Default maximum height = 150.0
        static let defaultMaxHeight: CGFloat = 150.0
        /// Default minimum input width = 80.0
        static let defaultMinInputWidth: CGFloat = 80.0
        /// Default tag height
        static let defaultTagHeight: CGFloat = 30.0

    
        static let defaultCornerRadius: CGFloat = 0.0
        /// Default border width
        static let defaultBorderWidth: CGFloat = 0.0
        /// Default color and selected textColor
        static let defaultTextColor: UIColor = UIColor.white
        /// Default color and selected textColor
        static let defaultTextInputColor: UIColor = UIColor(red: 38/255.0, green: 39/255.0, blue: 41/255.0, alpha: 1.0)
        /// Default text font
        static let defaultTextFont: UIFont = UIFont.systemFont(ofSize: 12)
        /// Default color, highlighted and selected backgroundColor, shadowColor
        static let defaultBackgroundColor: UIColor = UIColor.blue
        /// Default color and selected border Color
        static let defaultBorderColor: UIColor = UIColor.blue
        /// Default padding add to top and bottom of tag wrt font height
        static let defaultVerticalPadding: CGFloat = 2.0
        /// Default padding between view objects
        static let defaultHorizontalPadding: CGFloat = 5.0
        /// Default margin between tag rows
        static let defaultVerticalMargin: CGFloat = 2.0
        /// Default margin outside a tag row
        static let defaultHorizontalMargin: CGFloat = 2.0
        /// Default offset for shadow
        static let defaultShadowOffset: CGSize = CGSize.init(width: -20.0, height: 0.0)
        /// Default opacity for shadow
        static let defaultshadowOpacity: Float = 0
        /// Default to label text
        static let defaultPrefixLabelText: String = NSLocalizedString("To:", comment: "Text in the prefix label")
        /// Default to label text
        static let defaultNoPrefixLabel = false
        /// Default image used for the Clear and Remove button, similar to the one used in UITextField
        static let clearRemoveImage: UIImage? = UIImage.init(named: "Clear")
    }
    
    // MARK: - Inspectable Variables
    
    /// To label text color.
    @IBInspectable open dynamic var prefixLabelTextColor = Constants.defaultTextColor {
        didSet {
            if prefixLabel == nil {
                setupPrefixLabel()
            }
            prefixLabel?.textColor = prefixLabelTextColor
        }
    }
    
    /// To label text color.
    @IBInspectable open dynamic var prefixLabelBackgroundColor = Constants.defaultBackgroundColor {
        didSet {
            if prefixLabel == nil {
                setupPrefixLabel()
            }
            prefixLabel?.backgroundColor = prefixLabelBackgroundColor
        }
    }

    /// To label text.
    @IBInspectable open dynamic var prefixLabelText = Constants.defaultPrefixLabelText {
        didSet {
            if prefixLabel == nil {
                setupPrefixLabel()
            }
            prefixLabel?.text = prefixLabelText
            rearrangeViews(true)
        }
    }
    /// Input textView text color.
    @IBInspectable open dynamic var inputTextViewTextColor = Constants.defaultTextInputColor{
        didSet {
            inputTextView.textColor = inputTextViewTextColor
        }
    }
    
    @IBInspectable open dynamic var hasPrefixLabel = Constants.defaultNoPrefixLabel {
        didSet {
            if hasPrefixLabel && prefixLabel == nil {
                setupPrefixLabel()
            }
        }
    }

    @IBInspectable open dynamic var textColor = Constants.defaultTextColor {
        didSet {
            tagViews.forEach { $0.textColor = textColor }
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor = Constants.defaultTextColor {
        didSet {
            tagViews.forEach { $0.selectedTextColor = selectedTextColor }
        }
    }
    
    @IBInspectable open dynamic var highlightedTextColor = Constants.defaultTextColor {
        didSet {
            tagViews.forEach { $0.highlightedTextColor = highlightedTextColor }
        }
    }

    
    @IBInspectable open dynamic var tagBackgroundColor = Constants.defaultBackgroundColor {
        didSet {
            tagViews.forEach { $0.tagBackgroundColor = tagBackgroundColor }
        }
    }
    
    @IBInspectable open dynamic var tagHighlightedBackgroundColor = Constants.defaultBackgroundColor {
        didSet {
            tagViews.forEach { $0.tagHighlightedBackgroundColor = tagHighlightedBackgroundColor }
        }
    }
    
    @IBInspectable open dynamic var tagSelectedBackgroundColor = Constants.defaultBackgroundColor {
        didSet {
            tagViews.forEach { $0.tagSelectedBackgroundColor = tagSelectedBackgroundColor }
        }
    }
    
    @IBInspectable open dynamic var cornerRadius = Constants.defaultCornerRadius {
        didSet {
            // requires rearrangig the tagViews.
            rearrangeViews(true)
        }
    }
    @IBInspectable open dynamic var borderWidth = Constants.defaultBorderWidth {
        didSet {
            tagViews.forEach { $0.borderWidth = borderWidth }
        }
    }
    
    @IBInspectable open dynamic var borderColor = Constants.defaultBorderColor {
        didSet {
            tagViews.forEach { $0.borderColor = borderColor }
        }
    }
    
    @IBInspectable open dynamic var selectedBorderColor = Constants.defaultBorderColor {
        didSet {
            tagViews.forEach { $0.selectedBorderColor = selectedBorderColor }
        }
    }
    
    @IBInspectable open dynamic var highlightedBorderColor = Constants.defaultBorderColor {
        didSet {
            tagViews.forEach { $0.highlightedBorderColor = highlightedBorderColor }
        }
    }

    
    @IBInspectable open dynamic var verticalPadding = Constants.defaultVerticalPadding {
        didSet {
            rearrangeViews(true)
        }
    }
    @IBInspectable open dynamic var horizontalPadding = Constants.defaultHorizontalPadding {
        didSet {
            rearrangeViews(true)
        }
    }
    @IBInspectable open dynamic var verticalMargin = Constants.defaultVerticalMargin {
        didSet {
            rearrangeViews(true)
        }
    }
    @IBInspectable open dynamic var horizontalMargin = Constants.defaultHorizontalMargin {
        didSet {
            rearrangeViews(true)
        }
    }
    
    @objc public enum Alignment: Int {
        case left
        case center
        case right
    }
    @IBInspectable open var alignment: Alignment = .left {
        didSet {
            rearrangeViews(true)
        }
    }
    
    @IBInspectable open dynamic var shadowColor = Constants.defaultBackgroundColor {
        didSet {
            tagViews.forEach { $0.shadowColor = shadowColor }
        }
    }
    
    @IBInspectable open dynamic var shadowRadius = Constants.defaultCornerRadius {
        didSet {
            tagViews.forEach { $0.shadowRadius = shadowRadius }
        }
    }
    
    @IBInspectable open dynamic var shadowOffset = Constants.defaultShadowOffset {
        didSet {
            tagViews.forEach { $0.shadowOffset = shadowOffset }
        }
    }
    
    @IBInspectable open dynamic var shadowOpacity = Constants.defaultshadowOpacity {
        didSet {
            tagViews.forEach { $0.shadowOpacity = shadowOpacity }
        }
    }
    
    @IBInspectable open dynamic var textFont = Constants.defaultTextFont {
        didSet {
            rearrangeViews(true)
        }
    }
    
    @IBInspectable open dynamic var clearRemoveImage: UIImage? = Constants.clearRemoveImage
    
    // MARK: - Public? variables

    /// Input textView accessibility label.
    public var inputTextViewAccessibilityLabel: String! {
        didSet {
            inputTextView.accessibilityLabel = inputTextViewAccessibilityLabel
        }
    }

    // MARK: - Private
    
    /// TagListView's maximum height value.
    private var maxHeight: CGFloat = Constants.defaultMaxHeight
    
    /// TagListView's minimum input text width.
    private var minInputWidth: CGFloat = Constants.defaultMinInputWidth
    
    /// Keyboard type inital value .default.
    public var inputTextViewKeyboardType: UIKeyboardType = .default
    
    /// Keyboard appearance initial value .default.
    public var keyboardAppearance: UIKeyboardAppearance = .default
    
    /// Autocorrection type for textView initial value .no
    public var autocorrectionType: UITextAutocorrectionType = .no {
        didSet {
            inputTextView.autocorrectionType = autocorrectionType
        }
    }
    /// Autocapitalization type for textView inital value .sentences
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences {
        didSet {
            inputTextView.autocapitalizationType = autocapitalizationType
        }
    }
    /// Input accessory view for textView.
    public var inputTextViewAccessoryView: UIView? {
        didSet {
            inputTextView.inputAccessoryView = inputTextViewAccessoryView
        }
    }

    
    /// - Returns: `Bool` value which is true if the TagListView is the first responder.
    override open var isFirstResponder: Bool {
        return super.isFirstResponder
    }
    
    // MARK: - initializers
    
    /// Initializes a TagListView with a `CGRect` frame within it's superview.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    /// Initializer used by the storyboard to initialize a TagListView.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    /// TagListView override of UIView's awakeFromNib() function. Calls super.awakeFromNib() and then self.setup().
    override open func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }
    
    private var originalHeight: CGFloat = 0.0
    
    private func initSetup() {
        originalHeight = frame.height
        
        // addSubview(scrollView)
        reloadData()
    }
    
    // MARK: - First Responder Functions

    /// Resigns first responder.
    override open func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return inputTextView.resignFirstResponder()
    }
    
    /// TagListView calls self.layoutTagsAndInputWithFrameAdjustment(true) and self.inputTextViewBecomeFirstResponder()
    /// - Returns: Always returns `true`
    override open func becomeFirstResponder() -> Bool {
        rearrangeViews(true)
        inputTextViewBecomeFirstResponder()
        return true
    }

    fileprivate func setCursorVisibility() {
        let highlightedTagViews = tagViews.filter { $0.isHighlighted }
        if highlightedTagViews.count == 0 {
            inputTextViewBecomeFirstResponder()
        } else {
            invisibleTextView.becomeFirstResponder()
        }
    }
    
    private func inputTextViewBecomeFirstResponder() {
        guard !inputTextView.isFirstResponder else { return }
        inputTextView.becomeFirstResponder()
        // delegate?.tagListViewDidBeginEditing(self)
    }

    // MARK: - The Views
    
    // Prefix label, is only created when needed
    // It is shown in front of all tags
    
    private var prefixLabel: UILabel? = nil
    
    private func setupPrefixLabel() {
        prefixLabel = UILabel(frame: CGRect.zero)
        prefixLabel?.textColor = prefixLabelTextColor
        prefixLabel?.backgroundColor = prefixLabelBackgroundColor
        prefixLabel?.font = textFont
        prefixLabel?.text = prefixLabelText
        prefixLabel?.isHidden = false
    }
    
    // This textView has no size and is only to intervene for deletion
    
    private lazy var invisibleTextView: BackspaceTextView = {
        let invisibleTextView = BackspaceTextView(frame: CGRect.zero)
        invisibleTextView.autocorrectionType = self.autocorrectionType
        invisibleTextView.autocapitalizationType = self.autocapitalizationType
        invisibleTextView.backspaceDelegate = self
        return invisibleTextView
    }()
    
    // The TextView that allows the user to enter a new tag

    private lazy var inputTextView: UITextView = {
        let inputTextView = BackspaceTextView()
        inputTextView.keyboardType = self.inputTextViewKeyboardType
        inputTextView.textColor = self.inputTextViewTextColor
        inputTextView.font = self.textFont
        inputTextView.autocorrectionType = self.autocorrectionType
        inputTextView.autocapitalizationType = self.autocapitalizationType
        inputTextView.tintColor = UIColor.lightGray
        inputTextView.isScrollEnabled = false
        inputTextView.textContainer.lineBreakMode = .byWordWrapping
        inputTextView.delegate = self
        inputTextView.backspaceDelegate = self
        // TODO: - Add placeholder to BackspaceTextView and set it here
        inputTextView.accessibilityLabel = self.accessibilityLabel ?? Constants.defaultPrefixLabelText
        inputTextView.inputAccessoryView = self.inputTextViewAccessoryView
        inputTextView.accessibilityLabel = self.inputTextViewAccessibilityLabel
        inputTextView.textAlignment = .left
        inputTextView.backgroundColor = UIColor.lightGray
        return inputTextView
    }()
    
    // The label shown when the TagLisView is in collapsed state
    
    private lazy var collapsedLabel: UILabel = {
        let collapsedLabel = UILabel()
        collapsedLabel.font = self.textFont
        collapsedLabel.text = self.datasource?.tagListViewCollapsedText?(self) ?? "This is a collapsed label"
        collapsedLabel.textColor = .green //Constants.defaultTextInputColor
        collapsedLabel.backgroundColor = .white
        collapsedLabel.minimumScaleFactor = 5.0 / collapsedLabel.font.pointSize
        collapsedLabel.adjustsFontSizeToFitWidth = true
        return collapsedLabel
    }()
    
    private lazy var tagView: TagView = {
        let tagView = TagView(title: "")
        tagView.delegate = self
        tagView.textColor = self.textColor
        tagView.selectedTextColor = self.selectedTextColor
        tagView.highlightedTextColor = self.highlightedTextColor
        tagView.tagBackgroundColor = self.tagBackgroundColor
        tagView.tagHighlightedBackgroundColor = self.tagHighlightedBackgroundColor
        tagView.tagSelectedBackgroundColor = self.tagSelectedBackgroundColor
        tagView.cornerRadius = self.cornerRadius
        tagView.borderWidth = self.borderWidth
        tagView.borderColor = self.borderColor
        tagView.selectedBorderColor = self.selectedBorderColor
        tagView.highlightedBorderColor = self.highlightedBorderColor
        tagView.horizontalPadding = self.horizontalPadding
        tagView.verticalPadding = self.verticalPadding
        tagView.textFont = self.textFont
        tagView.isSelected = false
        tagView.isHighlighted = false
        tagView.removeButtonIsEnabled = false
        // tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        // tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)
        
        /*
         These seems to interfere with the longPress for reordering.
         Why have the longPress executed by the tagView?
         It is supposed to be a function that works on all tagViews, i.e.
         We could add a longPress gesture if isEditable = false,
         but that evades the logic of isEditable.
         However it does not break things.
         Maybe I should make isEditable optional. If nil it is the past implementation. If true or false the future implementation.
         if !allowReordering {
         // On long press, deselect all tags except this one
         tagView.onLongPress = { [unowned self] this in
         for tag in self.tagViews {
         tag.isSelected = (tag == this)
         }
         }
         }
         */
        
        return tagView
    }()

    private struct Clear {
        static let ImageSize: CGFloat = 14.0
        static let ViewSize: CGFloat = 22.0
    }
    
    private var clearView: UIView = {
        
        let clearImageView = UIImageView.init(image: UIImage.init(named: "Clear"))
        clearImageView.frame.size = CGSize.init(width: Clear.ImageSize, height: Clear.ImageSize)
        clearImageView.contentMode = .scaleAspectFit
        if Clear.ViewSize > Clear.ImageSize {
            clearImageView.frame.origin.x = (Clear.ViewSize - Clear.ImageSize) / 2.0
            clearImageView.frame.origin.y = (Clear.ViewSize - Clear.ImageSize) / 2.0
        } else {
            assert(true, "ImageView can not be larger than Image")
        }
        
        // put the image in another view in order to have a margin around the image
        let clearView = UIView(frame: CGRect.init(x: 0, y: 0, width: Clear.ViewSize, height: Clear.ViewSize))

        clearView.addSubview(clearImageView)
        
        return clearView
    }()
    
    fileprivate func unhighlightAllTags() {
        for tag in tagViews {
            tag.isHighlighted = false
        }
        setCursorVisibility()
    }

    // MARK: - Private
    
    /*private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: self.frame.width,
                height: self.frame.height
            )
        )
        scrollView.scrollsToTop = false
        scrollView.contentSize = CGSize(
            width: self.frame.width - self.horizontalPadding * 2,
            height: self.frame.height - self.verticalPadding * 2
        )
        scrollView.contentInset = UIEdgeInsets(
            top: self.verticalPadding,
            left: self.horizontalPadding,
            bottom: self.verticalPadding,
            right: self.horizontalPadding
        )
        scrollView.autoresizingMask = [
            UIViewAutoresizing.flexibleHeight,
            UIViewAutoresizing.flexibleWidth
        ]
        return scrollView
    }()
 */
    
    
    private var tagViews: [TagView] = []
    
    /*
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        
        addTag("Welcome")
        addTag("to")
        selectTag(at: tagViews.index(of: addTag("TagListView"))!)
    }
     */
    
    // MARK: - Layout functions
    
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        // Check in which state TagListView is
        if isCollapsed {
            layoutCollapsedLabel()
        } else {
            rearrangeViews(false)
        }
    }
    
    // Reload's the TagListView's data and layout it's views.
    public func reloadData() {
        guard datasource?.numberOfTagsIn(self) != nil else { return }
        
        clearTagListView()
        
        // Setup the tagView array and load the data here
        for index in 0..<datasource!.numberOfTagsIn(self) {
            let tagView = TagView(title: datasource?.tagListView(self, titleForTagAt: index) != nil ? datasource!.tagListView(self, titleForTagAt: index) : "")
            tagView.delegate = self
            tagView.tag = index
            tagView.textColor = self.textColor
            tagView.selectedTextColor = self.selectedTextColor
            tagView.highlightedTextColor = self.highlightedTextColor
            tagView.tagBackgroundColor = self.tagBackgroundColor
            tagView.tagHighlightedBackgroundColor = self.tagHighlightedBackgroundColor
            tagView.tagSelectedBackgroundColor = self.tagSelectedBackgroundColor
            tagView.borderWidth = self.borderWidth
            tagView.borderColor = self.borderColor
            tagView.selectedBorderColor = self.selectedBorderColor
            tagView.highlightedBorderColor = self.highlightedBorderColor
            tagView.isSelected = false
            tagView.isHighlighted = false
            tagView.removeButtonIsEnabled = false
            tagViews.append(tagView)
        }
        // Layout all the new TagViews
        rearrangeViews(true)
    }
    
    private func clearTagListView() {
        clearUncollapsedView()
        tagViews = []
    }
    
    // remove all Views which are part of the uncollapsed state except the prefix
    private func clearUncollapsedView() {
        // TODO: is this OK?
        tagViews.forEach { $0.removeFromSuperview() }
        inputTextView.removeFromSuperview()
        invisibleTextView.removeFromSuperview()
        rowViews.removeAll(keepingCapacity: true)
        clearView.removeFromSuperview()
    }

    private func rearrangeViews(_ shouldAdjustFrame: Bool) {
        
        clearUncollapsedView()
        
        let inputViewShouldBecomeFirstResponder = inputTextView.isFirstResponder
        //scrollView.subviews.forEach { $0.removeFromSuperview() }
        //scrollView.isHidden = false
        
        if tapGestureRecognizer != nil {
            removeGestureRecognizer(tapGestureRecognizer!)
            tapGestureRecognizer = nil
        }
        
        var currentX: CGFloat = 0.0
        var currentY: CGFloat = 0.0

        // Add the possibility to intercept a backspace for last tag removal
        if isEditable && allowsRemoval {
            addSubview(invisibleTextView)
        }

        // Add the prefix Label
        
        if hasPrefixLabel {
            layoutPrefixLabel(origin: CGPoint.zero, currentX: &currentX)
        }
        
        layoutTagViewsWith(currentX: &currentX, currentY: &currentY)
        
        if isEditable && allowsCreation {
            layoutInputTextViewWith(currentX: &currentX, currentY: &currentY, clearInput: shouldAdjustFrame)
        }
        if shouldAdjustFrame {
            adjustHeightFor(currentY: currentY)
        }
        
        if isEditable && allowsRemoval {
            layoutClearView()
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TagListView.clearOnTap(_:)))
        if tapGestureRecognizer != nil {
            clearView.addGestureRecognizer(tapGestureRecognizer!)
        }

        //scrollView.contentSize = CGSize(
        //    width: scrollView.contentSize.width,
        //    height: currentY + inputTextView.frame.height
        //)
        
        //scrollView.isScrollEnabled = scrollView.contentSize.height > maxHeight
        
        if inputViewShouldBecomeFirstResponder {
            inputTextViewBecomeFirstResponder()
        } else {
            // focusInputTextView(currentX: &currentX, currentY: &currentY)
        }

        invalidateIntrinsicContentSize()
    }
    
    
    private func layoutCollapsedLabel() {
        
        // remove all the views from TagListView
        clearUncollapsedView()
        
        /*
         // reset the height of the TagListView to the original height
         var collapsedFrame = self.frame
         collapsedFrame.size.height = textFont.pointSize + 2 * verticalMargin
         frame = collapsedFrame
         adjustHeightFor(currentY: 0.0)
         
         //
         */
        var currentX: CGFloat = 0.0
        
        if hasPrefixLabel {
            layoutPrefixLabel(origin: CGPoint(x: Constants.defaultHorizontalMargin, y: Constants.defaultVerticalMargin), currentX: &currentX)
        }
        
        collapsedLabel.frame = CGRect(
            x: currentX,
            y: 0.0,
            // the label covers the whole view after any prefix label
            width: frame.size.width - currentX - Constants.defaultHorizontalMargin,
            height: frame.height
        )
        addSubview(collapsedLabel)
        
        // tapping on the collapsedLabel uncollapses it
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TagListView.uncollapseOnTap(_:)))
        addGestureRecognizer(tapGestureRecognizer!)
    }
    
    private func layoutPrefixLabel(origin: CGPoint, currentX: inout CGFloat) {
        guard prefixLabel != nil else { return }
        
        // prefixLabel!.removeFromSuperview()
        
        // Define the prefix label frame
        prefixLabel!.frame.origin.x = currentX
        prefixLabel!.frame.origin.y = verticalPadding
        // the width will be determined by the text in the label
        prefixLabel!.frame.size.height = prefixLabel!.font.pointSize + Constants.defaultVerticalPadding * 2
        
        prefixLabel!.sizeToFit()
        
        addSubview(prefixLabel!)
        
        // if the label is visible add some padding
        // and define the horizontal point for the next view
        currentX += prefixLabel!.isHidden ? 0.0 : prefixLabel!.frame.width + Constants.defaultHorizontalPadding
    }
    
    /// - Returns: the input text from the textView.
    //public var inputText: String {
    //    return inputTextView.text ?? ""
    //}

    private func layoutTagViewsWith(currentX: inout CGFloat, currentY: inout CGFloat) {
        
        var currentRow = 0
        // var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        // print("frame", frame.size)
        
        // are there any tags?
        guard tagViews.count > 0 else { return }
        
        // calculate the rowWidth available for tags
        var rowWidth = frame.size.width
        if isEditable && allowsRemoval {
            
        }
        rowWidth -= clearView.frame.width
        
        for tagView in tagViews {
            tagView.cornerRadius = self.cornerRadius
            tagView.horizontalPadding = self.horizontalPadding
            tagView.verticalPadding = self.verticalPadding
            tagView.textFont = self.textFont
            
            if self.isEditable && allowsRemoval {
                if datasource?.tagListView?(self, canEditTagAt: tagView.tag) != nil && datasource!.tagListView!(self, canEditTagAt: tagView.tag) {
                    tagView.removeButtonIsEnabled = true
                } else {
                    tagView.removeButtonIsEnabled = false
                }
            } else {
                tagView.removeButtonIsEnabled = false
            }
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > rowWidth {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                // currentRowView = UIView()
                // currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + verticalMargin)
                // currentRowView.backgroundColor = UIColor.lightGray
                // rowViews.append(currentRowView)
                // addSubview(currentRowView)
            }
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + horizontalMargin
            
            /*switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - horizontalMargin)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - horizontalMargin)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
            */
            tagView.backgroundColor = backgroundColor
            
            if currentX + tagView.frame.width <= rowWidth {
                // tagView fits in current line
                tagView.frame = CGRect(
                    x: currentX,
                    y: currentY,
                    width: tagView.frame.width,
                    height: tagView.frame.height
                )
            } else {
                // new line with TagViews
                currentY += tagView.frame.height + Constants.defaultVerticalPadding
                currentX = 0
                var tagWidth = tagView.frame.width
                if (tagWidth > frame.size.width) { // token is wider than max width
                    tagWidth = frame.size.width
                }
                tagView.frame = CGRect(
                    x: currentX,
                    y: currentY,
                    width: tagWidth,
                    height: tagView.frame.height
                )
            }
            // print("currentXY", currentX, currentY)
            tagView.shadowColor = shadowColor
            tagView.shadowOpacity = shadowOpacity
            tagView.shadowRadius = shadowRadius
            tagView.shadowOffset = shadowOffset
            //let tagBackgroundView = self.tagBackgroundView
            //tagBackgroundView.frame.origin = CGPoint(x: currentX, y: currentY)
            //tagBackgroundView.frame.size = tagView.bounds.size
            //addSubview(tagBackgroundView)
            addSubview(tagView)
            // print("currentRowView", currentRowView.frame.origin)
            // print("TagView", tagView.tagViewLabel.text!, tagView.frame.origin)
            // print("backgroundTagView", tagBackgroundView.frame.origin)
            //currentRowView.addSubview(tagView)
            // currentRowView.addSubview(tagBackgroundView)
            currentX += tagView.frame.width + horizontalPadding
            // print("NEWcurrentXY", currentX, currentY)

            //scrollView.addSubview(tagView)
        }
        rows = currentRow
    }

    private func layoutInputTextViewWith(currentX: inout CGFloat, currentY: inout CGFloat, clearInput: Bool) {
        
        var inputTextViewOrigin = CGPoint.init(x: currentX, y: currentY)
        
        //let inputHeight = inputTextView.intrinsicContentSize.height > Constants.defaultTagHeight
        //    ? inputTextView.intrinsicContentSize.height
        //    : Constants.defaultTagHeight
        let inputHeight = Constants.defaultTagHeight
        // Is there enough space for a reasonable inputTextView
        if currentX + Constants.defaultMinInputWidth >= frame.size.width {
            // start with a new row
            inputTextViewOrigin.x = CGFloat(0.0)
            inputTextViewOrigin.y = currentY + Constants.defaultTagHeight + Constants.defaultVerticalPadding
        }
        inputTextView.frame = CGRect(
            x: inputTextViewOrigin.x,
            y: inputTextViewOrigin.y,
            width: frame.width - currentX,
            height: inputHeight
        )
        currentX += inputTextView.frame.width
        currentY += inputTextView.frame.height
        // print("inputHeight",inputHeight)
        /*
        var exclusionPaths: [UIBezierPath] = []
        
        if hasPrefixLabel && inputTextView.frame.origin.y == prefixLabel.frame.origin.y {
            exclusionPaths.append(UIBezierPath(rect: prefixLabel.frame))
        }
        
        for tagView in tagViews {
            if inputTextView.frame.origin.y == tagView.frame.origin.y {
                
                var frame = tagView.frame
                frame.origin.y = 0.0
                
                exclusionPaths.append(UIBezierPath(rect: frame))
            }
        }
        inputTextView.textContainer.exclusionPaths = exclusionPaths
 */
        inputTextView.backgroundColor = .white
        if clearInput {
            inputTextView.text = ""
        }
        // scrollView.addSubview(inputTextView)
        // scrollView.sendSubview(toBack: inputTextView)
        // print("inputTextView origin", frame.origin.x, frame.origin.y)
        addSubview(inputTextView)
        // sendSubview(toBack: inputTextView)
    }

    /*private func focusInputTextView(currentX: CGFloat, currentY: CGFloat) {
        let contentOffset = scrollView.contentOffset
        let targetY = inputTextView.frame.origin.y + Constants.defaultTagHeight - maxHeight
        if targetY > contentOffset.y {
            scrollView.setContentOffset(
                CGPoint(x: currentX, y: targetY),
                animated: false
            )
        }
    }
    */
    
    private func layoutClearView() {
        
        // The clearView should only be added in editMode and if deletion is allowed
        
        // The clearView appears on the trailing edge
        // And vertically centered in the TagListView
        // Note that if TagListView is in another view, you might not see it.

        clearView.frame.origin.x = frame.size.width - clearView.frame.size.width
        clearView.frame.origin.y = (frame.size.height - clearView.frame.size.height) / 2.0
        
        addSubview(clearView)
    }
    
    private func adjustHeightFor(currentY: CGFloat) {
        let oldHeight = frame.size.height
        var newFrame = frame
        
        if currentY + Constants.defaultTagHeight > frame.height {
            if currentY + Constants.defaultTagHeight <= maxHeight {
                newFrame.size.height = currentY
                    + Constants.defaultTagHeight
                    + Constants.defaultVerticalMargin * 2
            } else {
                newFrame.size.height = maxHeight
            }
        } else {
            if currentY + Constants.defaultTagHeight > originalHeight {
                newFrame.size.height = currentY
                    + Constants.defaultTagHeight
                    + Constants.defaultVerticalMargin * 2
            } else {
                newFrame.size.height = maxHeight
            }
        }
        if oldHeight != newFrame.height {
            frame = newFrame
            // delegate?.tagListView(self, didChangeContent: newFrame.height)
        }
    }

    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + verticalMargin)
        if rows > 0 {
            height -= verticalMargin
        }
        return CGSize(width: frame.width, height: height)
    }
    
    // MARK: - TagView delegates
    
    public func didTapTagView(_ tagView: TagView) {
        tagPressed(tagView)
    }
    
    public func didTapRemoveButton(_ tagView: TagView) {
        removeTag(at: tagView.tag)
    }

    /*
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = self.tagView
        tagView.title = title
        return addTagView(tagView)
    }
    

    
    @discardableResult
    private func addTag(_ title: String) -> TagView {
        let tagView = self.tagView
        tagView.title = title
        return addTagView(tagView)
    }
    
    @discardableResult
    private func addTags(_ titles: [String]) -> [TagView] {
        var tagViews: [TagView] = []
        for title in titles {
            tagViews.append(createNewTagView(title))
        }
        return addTagViews(tagViews)
    }
    
    @discardableResult
    private func addTagViews(_ tagViews: [TagView]) -> [TagView] {
        for tagView in tagViews {
            self.tagViews.append(tagView)
            tagBackgroundViews.append(UIView(frame: tagView.bounds))
        }
        rearrangeViews(true)
        return tagViews
    }
    
    @discardableResult
    private func insertTag(_ title: String, at index: Int) -> TagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    
    @discardableResult
    private func addTagView(_ tagView: TagView) -> TagView {
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        rearrangeViews(true)
        
        return tagView
    }
    
    @discardableResult
    private func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        rearrangeViews(true)
        
        return tagView
    }
     */

    /*
    private func setTitle(_ title: String, at index: Int) {
        tagViews[index].title = title
        rearrangeViews(true)
    }
     */
    
    // MARK: - State variables
    
    open var isCollapsed = false {
        didSet {
            if isCollapsed {
                layoutCollapsedLabel()
            } else {
                collapsedLabel.removeFromSuperview()
            }
        }
    }
    
    open var isEditable = false {
        didSet {
            if isEditable {
                // selection status is no longer relevant
                deselectAllTags()
                allowsRemoval = true
                allowsReordering = true
                allowsCreation = true
            } else {
                // highlight status is no longer relevant
                tagViews.forEach { $0.isHighlighted = false }
                allowsRemoval = false
                allowsReordering = false
                allowsCreation = false
            }
        }
    }
        
    var allowsMultipleSelection = false
    
    var allowsCreation = false
    
    var allowsRemoval = false {
        didSet {
            if allowsRemoval {
                // note that the removeButton state is set in rearrange as it affects the layout.
                if datasource?.tagListView?(self, canEditTagAt: tagView.tag) != nil && datasource!.tagListView!(self, canEditTagAt: tagView.tag) {
                    tagView.isHighlighted = true
                } else {
                    tagView.isHighlighted = false
                }
            } else {
                // reset all highlight states
                tagViews.forEach { $0.isHighlighted = false }
            }
        }
    }

    open var removeButtonIsEnabled : Bool = true

    // MARK: - Tag handling
    
    /*
    private func removeTag(_ title: String) {
        // loop the array in reversed order to remove items during loop
        for index in stride(from: (tagViews.count - 1), through: 0, by: -1) {
            
            let tagView = tagViews[index]
            if tagView.tagViewLabel?.text == title {
                remove(tagView)
            }
        }
    }
     */

    private func removeTag(at index: Int) {
        if datasource?.tagListView!(self, canEditTagAt: index) != nil &&
            datasource!.tagListView!(self, canEditTagAt: index) {
            delegate?.tagListView!(self, willBeginEditingTagAt: index)
            delegate?.tagListView?(self, didDeleteTagAt: index)
            reloadData()
            delegate?.tagListView!(self, didEndEditingTagAt: index)
        }
    }
    
/*
    private func remove(_ tagView: TagView) {
        if let index = tagViews.index(of: tagView) {
            removeTag(at: index)
        }
    }
    
    
    private func removeAllTags() {
        let views = tagViews as [UIView] + tagBackgroundViews
        for view in views {
            view.removeFromSuperview()
        }
        tagViews = []
        tagBackgroundViews = []
        rearrangeViews(true)
    }

    private var tagsCount: Int {
        get {
            return tagViews.count
        }
    }
 */
    
    // MARK : Selection functions
    
    func deselectTag(at index: Int) {
        tagViews[index].isSelected = false
    }
    
    func selectTag(at index: Int) {
        if !allowsMultipleSelection {
            deselectAllTags()
        }
        tagViews[index].isSelected = true
    }
    
    open func deselectAllTags() {
        tagViews.forEach { $0.isSelected = false }
    }
    
    open var selectedTags: [Int] {
        get {
            var indeces: [Int] = []
            for (index, tagView) in tagViews.enumerated() {
                if tagView.isSelected {
                    indeces.append(index)
                }
            }
            return indeces
        }
    }

    private func filterDeselectionAt(_ index: Int) {
        // deselection only works when not in editMode
        if !isEditable {
            // has a deselection filter been defined
            if delegate?.tagListView?(self, willDeselectTagAt: index) != nil {
                // is it allowed to change the deselect state of this tag?
                if index == delegate?.tagListView?(self, willDeselectTagAt: index) {
                    // then select the tag
                    deselectTag(at: index)
                    delegate?.tagListView?(self, didDeselectTagAt: index)
                } else {
                    // no deselection allowed
                }
            } else {
                // always allow
                deselectTag(at: index)
                delegate?.tagListView?(self, didDeselectTagAt: index)
            }
        }
    }
    
    // Maybe this should be deprecated as it exposes to TagView
    private func selectTagIn(_ tagView: TagView) {
        if let validIndex = tagViews.index(of: tagView) {
            filterSelectionAt(validIndex)
        }
    }
    
    private func filterSelectionAt(_ index: Int) {
        if !isEditable {
            // has a selection filter been defined?
            if delegate?.tagListView?(self, willSelectTagAt: index) != nil {
                // is it allowed to change the select state of this tag?
                if index == delegate?.tagListView?(self, willSelectTagAt: index) {
                    // then select the tag
                    selectTag(at: index)
                    delegate?.tagListView?(self, didSelectTagAt: index)
                } else {
                    // no selection allowed
                }
            } else {
                selectTag(at: index)
                delegate?.tagListView?(self, didSelectTagAt: index)
            }
        }
    }

    // MARK: Index functions
    
    /*
    var indexForSelectedTag: Int? {
        get {
            for (index, tagView) in tagViews.enumerated() {
                if tagView.isSelected { return index }
            }
            return nil
        }
    }
 */
    
    private func indecesWithTag(_ title: String) -> [Int] {
        var indeces: [Int] = []
        for (index, tagView) in tagViews.enumerated() {
            if tagView.label?.text == title {
                indeces.append(index)
            }
        }
        return indeces
    }
    
    // MARK: - Events
    
    // Maybe this should be deprecated as it exposes to TagView
    private func tagPressed(_ sender: TagView!) {
        // sender.onTap?(sender)
        if isEditable {
            if let currentIndex = self.tagViews.index(of: sender) {
                removeTag(at: currentIndex)
            }
        } else {
            if let currentIndex = self.tagViews.index(of: sender) {
                sender.isSelected ? filterDeselectionAt(currentIndex) : filterSelectionAt(currentIndex)
            }
        }
        // delegate?.tagPressed?(sender.tagViewLabel?.text ?? "", tagView: sender, sender: self)
    }
    

    private func indexForTagViewAt(_ point: CGPoint) -> Int? {
        for (index, tagView) in tagViews.enumerated() {
            if tagView.frame.contains(self.convert(point, to: tagView)) {
                return index
            }
        }
        return nil
    }
    
    // MARK: - Tap handling
    
    private var tapGestureRecognizer: UITapGestureRecognizer?

    internal func uncollapseOnTap(_ sender: UITapGestureRecognizer) {
        isCollapsed = false
    }
    
    internal func clearOnTap(_ sender: UITapGestureRecognizer) {
        datasource?.didClear?(self)
        // reload in case the user changed the data
        reloadData()
    }
    
    // MARK: - Drag & Drop support
    
    open var allowsReordering = false {
        didSet {
            if allowsReordering {
                // if reordering is allowed setup the longPress gesture
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(TagListView.longPressGestureRecognized))
                self.addGestureRecognizer(longpress)
            }
        }
    }
    private var longPressViewSnapshot : UIView? = nil
    
    private var longPressInitialIndex : Int? = nil

    @objc private func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        func snapshotOfView(_ inputView: UIView) -> UIView {
            UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
            inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            let cellSnapshot : UIView = UIImageView(image: image)
            cellSnapshot.layer.masksToBounds = false
            cellSnapshot.layer.cornerRadius = 0.0
            cellSnapshot.layer.shadowOffset = CGSize.init(width: -5.0, height: 0.0)
            cellSnapshot.layer.shadowRadius = 5.0
            cellSnapshot.layer.shadowOpacity = 0.4
            return cellSnapshot
        }
        
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        
        let locationInView = longPress.location(in: self)
        // get the index of the tag where the longPress took place
        var index = indexForTagViewAt(longPress.location(in: self))
        
        func startReOrderingTagAt(_ sourceIndex: Int?) {
            
            let state = longPress.state
            switch state {
            case UIGestureRecognizerState.began:
                self.longPressInitialIndex = index
                if let sourceIndex = self.longPressInitialIndex {
                    if let canMoveTag = datasource?.tagListView?(self, canMoveTagAt: sourceIndex) {
                        // check if the user gives permission to move this tag
                        if canMoveTag {
                            // make only a snapshot if the tag is allowed to move
                            longPressViewSnapshot = snapshotOfView(tagViews[sourceIndex])
                            if longPressViewSnapshot != nil {
                                
                                longPressViewSnapshot!.isHidden = true
                                longPressViewSnapshot!.alpha = 0.0
                                addSubview(longPressViewSnapshot!)
                                
                                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                                    self.longPressViewSnapshot!.center = locationInView
                                    self.longPressViewSnapshot!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                                    self.longPressViewSnapshot!.alpha = 0.9
                                    self.tagViews[sourceIndex].alpha = 0.3
                                }, completion: { (finished) -> Void in
                                    if finished {
                                        self.tagViews[sourceIndex].isHidden = true
                                        self.longPressViewSnapshot!.isHidden = false
                                    }
                                })
                            }
                        }
                    }
                }
            case UIGestureRecognizerState.changed:
                if longPressViewSnapshot != nil {
                    // move the snapshot to current press location
                    longPressViewSnapshot!.center = locationInView
                    if let validDestinationIndex = index,
                        let validSourceIndex = self.longPressInitialIndex {
                        if validDestinationIndex != validSourceIndex {
                            // ask the user if the destinationIndex is allowed
                            if let userDefinedDestinationIndex = delegate?.tagListView?(self, targetForMoveFromTagAt: validSourceIndex, toProposed: validDestinationIndex) {
                                // use the destinationIndex value proposed by the user
                                moveTagAt(validSourceIndex, to: userDefinedDestinationIndex)
                                self.longPressInitialIndex = userDefinedDestinationIndex
                            } else {
                                // the user does not want to interfere, so default is to use the initial proposed target index
                                moveTagAt(self.longPressInitialIndex!, to: validDestinationIndex)
                                self.longPressInitialIndex = validDestinationIndex
                            }
                        }
                    }
                }
            default:
                if longPressViewSnapshot != nil {
                    if let validIndex = self.longPressInitialIndex {
                        tagViews[validIndex].isHidden = false
                        tagViews[validIndex].alpha = 0.0
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            self.longPressViewSnapshot!.center = self.tagViews[validIndex].center
                            self.longPressViewSnapshot!.transform = CGAffineTransform.identity
                            self.longPressViewSnapshot!.alpha = 0.0
                            self.tagViews[validIndex].alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.longPressInitialIndex = nil
                                self.longPressViewSnapshot!.removeFromSuperview()
                                self.longPressViewSnapshot = nil
                            }
                        })
                    } else {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            // My.viewSnapshot!.center = self.tagViews[validIndex].center
                            self.longPressViewSnapshot!.transform = CGAffineTransform.identity
                            self.longPressViewSnapshot!.alpha = 0.0
                            // self.tagViews[validIndex].alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.longPressInitialIndex = nil
                                self.longPressViewSnapshot!.removeFromSuperview()
                                self.longPressViewSnapshot = nil
                            }
                        })
                    }
                }
            }
        }
        
        func moveTagAt(_ fromIndex: Int, to toIndex: Int) {
            if fromIndex != toIndex {
                // give the user the chance to move the data
                datasource?.tagListView?(self, moveTagAt: fromIndex, to: toIndex)
                self.reloadData()
            }
        }
        
        startReOrderingTagAt(index)

    }
    
    // TBD This should only work in editMode?
    // TBD Is there a mixup between highlighted and selected?
    // The user can delete tags with a backspace
    func textViewDidEnterBackspace(_ textView: BackspaceTextView) {
        var tagViewDeleted = false
        // Is the tag under datasource control?
        if let tagCount = datasource?.numberOfTagsIn(self), tagCount > 0 {
            for (index, tagView) in tagViews.enumerated() {
                if tagView.isHighlighted {
                    delegate?.tagListView?(self, didDeleteTagAt: index)
                    tagViewDeleted = true
                    self.reloadData()
                    break
                }
            }
        }
        if !tagViewDeleted {
            if let last = tagViews.last {
                last.isHighlighted = true
            }
        }
        setCursorVisibility()
    }
    

    // MARK: - UITextViewDelegates
    
    public func textViewDidChange(_ textView: UITextView) {
        // unhighlightAllTags()
        // delegate?.tagListView?(self, didChange: textView.text ?? "")
    
        if textView.contentSize.height > textView.frame.height {
            rearrangeViews(true)
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //unhighlightAllTags()
        
        guard text != "\n" else {
            if !textView.text.isEmpty {
                delegate?.tagListView?(self, didAddTagWith: textView.text)
                textView.resignFirstResponder()
                self.reloadData()
            }
            return false
        }
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === inputTextView {
            unhighlightAllTags()
        }
    }
    
}
