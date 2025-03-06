///|
pub extern type Commands

///|
extern "js" fn Commands::register_command_ffi(
  command_id : String,
  callback : async (Array[@js.Value]) -> Unit!
) -> VSDisposable =
  #|(id, callback) => vscode.commands.registerCommand(id, (...args) => callback(args))

///|
extern "js" fn Commands::register_text_editor_command_ffi(
  command_id : String,
  callback : (TextEditor) -> Unit
) -> Unit =
  #|(id, callback) => vscode.commands.registerTextEditorCommand(id, (editor) => callback(editor))

///|
pub fn Commands::register_command[T](
  command_id : String,
  callback : async (Array[@js.Value]) -> T!
) -> VSDisposable {
  Commands::register_command_ffi(command_id, fn(args) {
    @js.Promise::new(async fn() { callback!!(args) }).wait!!().cast()
  })
}

///|
pub fn Commands::register_text_editor_command(
  command_id : String,
  callback : async (TextEditor) -> Unit!
) -> Unit {
  let callback = fn(editor) {
    @js.Promise::new(async fn() { callback!!(editor) }) |> ignore
  }
  Commands::register_text_editor_command_ffi(command_id, callback)
}
