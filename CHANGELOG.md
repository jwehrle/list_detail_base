## 0.0.1

* Initial release.

## 0.1.0

* First major improvements, breaking changes:
  * Fixed bugs around `TextField` interactions triggering rebuilds
  * Incorporated `InheretedWidget` pattern

## 0.2.0

* Really fixed the `TextField` interactions this time. It turns out LayoutBuilder is buggy and OrientationBuilder is actually a LayoutBuilder. These have now been completely avoided by depending on InheretedWidgets `View.of(context)` and `MediaQuery.of(context)`. Testng with `TextView` and changing orientation now always gives the anticipated result.

## 0.2.1

* Gave more detailed description and removed unused import.
