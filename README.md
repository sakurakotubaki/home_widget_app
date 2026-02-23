# home_widget_app

FlutterでiOS/Androidホームウィジェットを実装するサンプルアプリです。

## 使用パッケージ

- [home_widget](https://pub.dev/packages/home_widget) - FlutterとネイティブWidgetの連携

## iOSセットアップ

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

## Androidセットアップ

### 1. build.gradle.kts の設定

`android/app/build.gradle.kts` に以下を追加：

```kotlin
android {
    // ...
    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.14"
    }
}

dependencies {
    implementation("androidx.glance:glance-appwidget:1.1.1")
    implementation("androidx.glance:glance-material3:1.1.1")
}
```

### 2. Widget XMLの作成

`android/app/src/main/res/xml/my_widget_info.xml` を作成：

```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/glance_default_loading_layout"
    android:minWidth="110dp"
    android:minHeight="110dp"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="1800000"
    android:widgetCategory="home_screen">
</appwidget-provider>
```

### 3. Widget Kotlinクラスの作成

`android/app/src/main/kotlin/[package]/MyAppWidget.kt` と `MyAppWidgetReceiver.kt` を作成。

### 4. AndroidManifest.xmlへの登録

```xml
<receiver
    android:name=".MyAppWidgetReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/my_widget_info" />
</receiver>
```

## Flutterコードの設定

```dart
// App Group IDを設定 (iOS用)
await HomeWidget.setAppGroupId('group.com.jboycode.homeWidgetApp');

// データを保存
await HomeWidget.saveWidgetData<int>('counter', 0);
await HomeWidget.saveWidgetData<String>('message', 'Hello');

// ウィジェットを更新
await HomeWidget.updateWidget(
  name: 'MyAppWidget',          // Android用
  iOSName: 'MyWidget',          // iOS用
  androidName: 'MyAppWidget',   // Android用
);
```

## 参考資料

### ドキュメント

- [home_widget Android Setup](https://docs.page/abausg/home_widget/setup/android)

### YouTube

- [Flutter Home Widget Tutorial](https://www.youtube.com/watch?v=R2hLgysH6JA&t=138s)
- [Flutter iOS Widget Implementation](https://www.youtube.com/watch?v=Fe1n5wJ6E9g)
