# ManagedTagListView

Simple and highly customizable iOS tag list view, in Swift.

Supports Storyboard, Auto Layout, and @IBDesignable.

<img alt="Screenshot" src="Screenshots/Screenshot.png" width="310">

## Usage

The most convenient way is to use Storyboard. Drag a view to Storyboard and set Class to `TagListView` (if you use CocoaPods, also set Module to `TagListView`). Then you can play with the attributes in the right pane, and see the preview in real time thanks to [@IBDesignable](http://nshipster.com/ibinspectable-ibdesignable/).

<img alt="Interface Builder" src="Screenshots/InterfaceBuilder.png" width="566">

## Unmanaged or managed approach
The class can be used in unmanaged and managed mode. In unmanaged mode you add, setup and remove tags by yourself. In managed mode any interaction with the TagListView is handles through delegate- and datasource-functions. Be careful to mix the two modes. There might rest some problems.

## Unmanaged functions
You can add tag to the tag list view, or set custom font and alignment through code:
```swift
tagListView.addTag("TagListView")
tagListView.insertTag("This should be the second tag", at: 1)
tagListView.addTags(["Add","two","tags"])
tagListView.setTitle("New Title of tag", at: 3) // changes the taag at position 3
tagListView.removeTag("meow") // all tags with title “meow” will be removed
tagListView.removeAllTags()
```
### Selecting and deselecting tags
```swift
tagListView.selectedTags() // will give you the tagView of all the tags.
tagListView.deselectTag(at:4) // deselect tag at index 4
tagListView.selectTag(at:3) // select tag at index 3
tagListView.deselectAllTags() // deselect all tags
tagListView.allowsMultipleSelection = true // allow the user to select multiple tags
```
### Edit mode
TagListView can be set as editable or not. If the TagListView is editable, any tapping on a tag will be interpreted as a removal instruction. 
As default a tagListView is not editable.
```swift
tagListView.isEditable = true // sets tagListView in editable-mode.
```
In editMode the removability of a tag will be highlighted with a special icon. You can set some characteristics of this icon with:
```swift
tagListView.removeIconLineWidth = 1
tagListView.removeButtonIconSize = 12
tagListView.removeIconLineColor = UIColor.white.withAlphaComponent(0.54)
```
### Finding tags
You can find the index of specific tags or titles with:
```swift
- tagListView.indexForSelectedTag: Int? {
- tagListView.indecesForSelectedTags: [Int] {
- tagListView.indecesWithTag(_ title: String) -> [Int] {
```
## Managed functions
The managed functions allow you to use TagListView from delegate and datasource-functions.
### Delegate/Datasource functions
TagViewList support several delegate and datasource functions, which you can use. First setup your viewController as delegate:
```swift
class YourViewController: UIViewController, TagListViewDelegate
```
Then assign yourself as a delegate of TagListView. For instance in a didSet of your TagListView outlet:
```swift
tagListView.delegate = self
tagListView.datasource = self

```
#### Delegate functions

You can intercept events around tapping on tags. This will set a tag to being selected.
```swift
func tagListView(_ tagListView: TagListView, didSelectTagAtIndex index: Int) -> Void
func tagListView(_ tagListView: TagListView, willSelectTagAtIndex index: Int) -> Int
func tagListView(_ tagListView: TagListView, didDeselectTagAtIndex index: Int) -> Void
func tagListView(_ tagListView: TagListView, willDeselectTagAtIndex index: Int) -> Int
func tagPressed(title: String, tagView: TagView, sender: TagListView)
```
You can intercept the edit-instructions with the appropriate delegate functions.
```swift
func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int)
func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int)
```
If you allow the user to move tags:
```swift
func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int, toProposed proposedDestinationIndex: Int) -> Int
```
#### Datasource functions
```swift
func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool
func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool
func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int)
```
### Layouting tags
It is also possible to layout the tagViews is a tagListView with:
```swift
tagListView.textColor = UIColor.white
tagListView.selectedTextColor = UIColor.white
tagListView.tagBackgroundColor = UIColor.gray
tagListView.tagHighlightedBackgroundColor = UIColor.blue
tagListView.tagSelectedBackgroundColor = UIcolor.green
tagListView.cornerRadius = 0
tagListView.borderWidth = 0
tagListView.borderColor = UIColor.black
tagListView.selectedBorderColor: UIColor?
tagListView.vertcalPadding = 2
tagListView.horizontalPadding = 5
tagListView.verticalMargin = 2
tagListView.horizontalMargin = 5
tagListView.textFont = UIFont.systemFontOfSize(24)
tagListView.alignment = .Center // possible values are .Left, .Center, and .Right
tagListView.alignment = UIFont.systemFont(ofSize: 15)
tagListView.alignment.shadowRadius = 2
tagListView.alignment.shadowOpacity = 0.4
tagListView.alignment.shadowColor = UIColor.black
tagListView.alignment.shadowOffset = CGSize(width: 1, height: 1)
tagListView.hasPrefixLabel = true
```

You can also customize a particular tag, or set tap handler for it by manipulating the `TagView` object returned by `addTag(_:)`:

```swift
let tagView = tagListView.addTag("blue")
tagView.tagBackgroundColor = UIColor.blueColor()
tagView.onTap = { tagView in
print("Don’t tap me!")
}
```

Be aware that if you update a property (e.g. `tagBackgroundColor`) for a `TagListView`, all the inner `TagView`s will be updated.

## Installation

Drag the **TagListView** folder into your project.

## Acknowledgments


## License

MIT
