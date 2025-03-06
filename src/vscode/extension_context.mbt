///|
pub extern type ExtensionContext

///|
pub extern "js" fn ExtensionContext::get_subscriptions(
  self : ExtensionContext
) -> Array[VSDisposable] =
  #|(self) => self.subscriptions
