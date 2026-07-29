# Firebase の ComponentRegistrar を R8 から保護する。
#
# 各 Firebase ライブラリは AndroidManifest の <meta-data> に ComponentRegistrar の
# クラス名を登録し、起動時に ComponentDiscovery がリフレクションで生成する。R8 は
# この参照を追えないため引数なしコンストラクタを削除してしまい、以下のように
# FirebaseApp の初期化そのものが失敗する。
#
#   W/ComponentDiscovery: Could not instantiate CrashlyticsRegistrar
#     Caused by: java.lang.NoSuchMethodException: CrashlyticsRegistrar.<init> []
#   ...
#   Caused by: java.lang.NullPointerException: FirebaseCrashlytics component is not present.
#
# Flutter は release ビルドで常に R8 を有効にするが (FlutterPlugin.kt の
# isMinifyEnabled = true)、AGP 9 に同梱される R8 で削除されるようになり顕在化した。
# このファイルは android/app/proguard-rules.pro に置くと Flutter の Gradle プラグインが
# 自動で proguardFiles へ追加する。
-keep class * implements com.google.firebase.components.ComponentRegistrar {
    <init>();
}
