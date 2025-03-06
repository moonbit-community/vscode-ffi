///|
extern "js" fn import_vscode() -> Unit = "() => { globalThis.vscode = require('vscode') }"

///|
fn init {
  import_vscode()
}
