///|
pub extern type VSDisposable

///|
pub extern "js" fn VSDisposable::dispose(self : VSDisposable) =
  #|(self) => self.dispose()

///|
trait Disposable {
  dispose(Self) -> Unit
}

///|
pub fn &Disposable::to_vs(self : &Disposable) -> VSDisposable {
  let object = @js.Object::new()
  object["dispose"] = fn() { self.dispose() }
  object._.cast()
}
