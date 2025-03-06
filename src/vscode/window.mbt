///|
pub extern type Window

///|
struct MessageOptions {
  modal : Bool?
  detail : String?
}

///|
fn MessageOptions::to_js(self : MessageOptions) -> @js.Value {
  let object = @js.Object::new()
  object["modal"] = @js.Optional::from_option(self.modal)
  object["detail"] = @js.Optional::from_option(self.detail)
  object._
}

///|
pub fn MessageOptions::new(modal? : Bool, detail? : String) -> MessageOptions {
  MessageOptions::{ modal, detail }
}

///|
pub struct MessageItem[T] {
  title : String
  is_close_affordance : Bool?
  payload : T
}

///|
pub fn MessageItem::new[T](
  title~ : String,
  is_close_affordance? : Bool,
  payload~ : T
) -> MessageItem[T] {
  MessageItem::{ title, is_close_affordance, payload }
}

///|
fn MessageItem::to_js[T](self : MessageItem[T]) -> @js.Value {
  let object = @js.Object::new()
  object["title"] = @js.Value::cast_from(self.title)
  object["isCloseAffordance"] = @js.Optional::from_option(
    self.is_close_affordance,
  )
  object["_"] = @js.Value::cast_from(self)
  object._
}

///|
fn MessageItem::from_js[T](value : @js.Value) -> T {
  value.get_with_string("_")
}

///|
extern "js" fn Window::show_information_message_ffi(
  message : String,
  rest : Array[@js.Value]
) -> @js.Promise = "(message, rest) => vscode.window.showInformationMessage(message, ...rest)"

///|
pub async fn Window::show_information_message(
  message : String,
  message_options? : MessageOptions,
  items? : Array[String]
) -> String! {
  let rest = []
  if message_options is Some(message_options) {
    rest.push(message_options.to_js())
  }
  if items is Some(items) {
    items.each(fn(item) { rest.push(@js.Value::cast_from(item)) })
  }
  Window::show_information_message_ffi(message, rest).wait!!().cast()
}

///|
pub async fn Window::show_information_message_items[T](
  message : String,
  message_options? : MessageOptions,
  items? : Array[MessageItem[T]]
) -> MessageItem[T]! {
  let rest = []
  if message_options is Some(message_options) {
    rest.push(message_options.to_js())
  }
  if items is Some(items) {
    items.each(fn(item) { rest.push(item.to_js()) })
  }
  let js_item = Window::show_information_message_ffi(message, rest).wait!!()
  MessageItem::from_js(js_item)
}

///|
pub extern "js" fn Window::get_active_text_editor() -> TextEditor = "() => vscode.window.activeTextEditor"
