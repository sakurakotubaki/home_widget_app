# home_widget_app

FlutterでiOSホームウィジェットを実装するサンプルアプリです。

## 使用パッケージ

- [home_widget](https://pub.dev/packages/home_widget) - FlutterとネイティブWidgetの連携

## セットアップ手順

### 1. iOS最小バージョンの設定

`ios/Podfile` でiOSの最小バージョンを14.0以上に設定：

```ruby
platform :ios, '14.0'
```

### 2. App Groupの設定

FlutterアプリとWidget Extensionでデータを共有するため、App Groupを設定します。

#### Xcodeでの設定

1. `ios/Runner.xcworkspace` をXcodeで開く
2. **Runner** ターゲット → **Signing & Capabilities** → **+ Capability** → **App Groups** を追加
3. App Group IDを追加（例: `group.com.jboycode.homeWidgetApp`）
4. **MyWidgetExtension** ターゲットにも同じApp Groupを追加

### 3. Widget Extensionの追加

1. Xcodeで **File** → **New** → **Target** → **Widget Extension** を選択
2. 名前を「MyWidget」に設定
3. **Include Configuration App Intent** のチェックを外す

### 4. ビルドサイクルエラーの修正

Widget Extension追加後にビルドサイクルエラーが発生する場合：

1. Xcodeで **Runner** ターゲット → **Build Phases** タブを開く
2. **「Embed Foundation Extensions」** を **「Thin Binary」** より上にドラッグして移動

## Flutterコードの設定

```dart
// App Group IDを設定
await HomeWidget.setAppGroupId('group.com.jboycode.homeWidgetApp');

// データを保存
await HomeWidget.saveWidgetData<int>('counter', 0);
await HomeWidget.saveWidgetData<String>('message', 'Hello');

// ウィジェットを更新
await HomeWidget.updateWidget(
  name: 'MyWidget',
  iOSName: 'MyWidget',
);
```

## 参考資料

### YouTube

- [Flutter Home Widget Tutorial](https://www.youtube.com/watch?v=R2hLgysH6JA&t=138s)
- [Flutter iOS Widget Implementation](https://www.youtube.com/watch?v=Fe1n5wJ6E9g)
