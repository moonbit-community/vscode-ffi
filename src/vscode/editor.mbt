///|
pub extern type TextEditor

///|
pub(all) enum TextEditorRevealType {
  Default = 0
  InCenter = 1
  InCenterIfOutsideViewport = 2
  AtTop = 3
}

///|
pub extern "js" fn TextEditor::reveal_range(
  self : TextEditor,
  range : Range,
  reveal_type~ : TextEditorRevealType = Default
) -> Unit =
  #|(self, range, revealType) => self.revealRange(range, revealType)

///|
pub extern "js" fn TextEditor::get_selection(self : TextEditor) -> Selection =
  #|(self) => self.selection

///|
pub extern type Position

///|
pub extern "js" fn Position::new(line : Int, character : Int) -> Position =
  #|(line, character) => new vscode.Position(line, character)

///|
pub extern "js" fn Position::line(self : Position) -> Int =
  #|(self) => self.line

///|
pub extern "js" fn Position::character(self : Position) -> Int =
  #|(self) => self.character"

///|
pub extern "js" fn Position::isBefore(
  self : Position,
  other : Position
) -> Bool =
  #|(self, other) => self.isBefore(other)

///|
pub extern type Range

///|
pub extern "js" fn Range::new_from_positions(
  start : Position,
  end : Position
) -> Range =
  #|(start, end) => new vscode.Range(start, end)

///|
pub extern "js" fn Range::new_from_coordinates(
  start_line : Int,
  start_character : Int,
  end_line : Int,
  end_character : Int
) -> Range =
  #|(start_line, start_character, end_line, end_character) => new vscode.Range(
  #|  start_line,
  #|  start_character,
  #|  end_line,
  #|  end_character
  #|)

///|
pub extern type Selection

///|
pub fn Selection::to_range(self : Selection) -> Range = "%identity"
