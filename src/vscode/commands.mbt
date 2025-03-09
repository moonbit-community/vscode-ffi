///|
pub extern type VSDisposable

///|
extern "js" fn VSDisposable::dispose(self : VSDisposable) =
  #|(self) => self.dispose()

///|
trait Disposable {
  dispose(Self) -> Unit
}

///|
impl Disposable for VSDisposable with dispose(self) {
  self.dispose()
}

///|
pub fn &Disposable::to_vs(self : &Disposable) -> VSDisposable {
  let object = @js.Object::new()
  object["dispose"] = fn() { self.dispose() }
  object._.cast()
}

///|
pub extern type Commands

///|
extern "js" fn Commands::register_command_ffi(
  command_id : String,
  callback : async (Array[@js.Value]) -> Unit!
) -> VSDisposable =
  #|(id, callback) => {
  #|  vscode.commands.registerCommand(id, (...args) => {
  #|    return new Promise((res, rej) => callback(args, res, rej))
  #|  })
  #|}

///|
extern "js" fn Commands::register_text_editor_command_ffi(
  command_id : String,
  callback : (TextEditor) -> Unit
) -> VSDisposable =
  #|(id, callback) => vscode.commands.registerTextEditorCommand(id, (editor) => callback(editor))

///|
extern "js" fn Commands::execute_command_ffi(
  command_id : String,
  args : Array[@js.Value]
) -> @js.Promise =
  #|(id, args) => vscode.commands.executeCommand(id, ...args)

///|
pub fn Commands::register_command[T](
  command_id : String,
  callback : async (Array[@js.Value]) -> T!
) -> VSDisposable {
  Commands::register_command_ffi(command_id, async fn(args) {
    @js.Promise::new(async fn() { callback!!(args) }).wait!!().cast()
  })
}

///|
pub fn Commands::register_text_editor_command(
  command_id : String,
  callback : async (TextEditor) -> Unit!
) -> VSDisposable {
  let callback = fn(editor) {
    @js.Promise::new(async fn() { callback!!(editor) }) |> ignore
  }
  Commands::register_text_editor_command_ffi(command_id, callback)
}

///|
pub async fn Commands::execute_command[T](
  command_id : String,
  args : Array[@js.Value]
) -> T! {
  Commands::execute_command_ffi(command_id, args).wait!!().cast()
}
