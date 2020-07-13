## Widgetを作るまとめ

AppにWidgetを追加すするために新しいTargetを追加する必要あります。

追加方法：

- XcodeでFile > New > Target
- Application Extension GroupからWidget Extension を選択して、次を押す
- 名前を入力
- user-configurable propertiesある場合は、Configuration Intentにチェックを入れる
- Finishを押す

#### Widgetのエントリポイント

@mainのキーワードをついているstructがWidgetのエントリポイントになります。そのstructはWidgetプロトコルを準拠している必要があります。

```swift
@main
struct Covid19TrackerWidget: Widget {
    private let kind: String = "Covid19TrackerWidget"

        public var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind,
                                provider: Covid19CountryStatusProvider(),
                                placeholder: PlaceholderView())
            { entry in
                Covid19CountryStatusEntryView(entry: entry)
            }
            .configurationDisplayName("Covid19 Tracker")
            .description("Shows Latest Information About Covid 19")　
        }
}
```

Widget作成ためには上通りに書きます。bodyの型はWidgetConfigurationになっています。WidgetConfigurationは、このWidgetとは何か、どのように構築されるかを示しますが。

#### WidgetConfiguration

WidgetConfigurationは二種類あります

- StaticConfiguration
- IntentConfiguration

#### StaticConfiguration

`init(kind: String, provider: TimelineProvider, placeholder: View, content: (TimeLineEntry) - _)`

ユーザー設定可能なプロパティ（user-configurable properties）ない場合



#### IntentConfiguration

`IntentConfiguration(kind: String, intent: INIntent.Type, provider:IntentTimelineProvider, placeholder: View, content: (TimelineEntry) -> _)`

ユーザー設定可能なプロパティ（user-configurable properties）ある場合。プロパティを定義するためはSiriKit custom intentを利用します。



##### IntentConfigurationとStaticConfigurationのinitの違い

- IntentConfigurationではproviderがTimelineProviderではなくIntentTimelineProvider利用します。
- INIntent.Type型の引数が追加で必要

#### Configurationの引数について

- kind

  Widgetを識別する文字列。基本的にSwiftファイル名と同じ

  ```swift
  FileName: Covid19TrackerWidget.swift 
  @main
  struct Covid19TrackerWidget: Widget {
      private let kind: String = "Covid19TrackerWidget"
    ...省略...
  ```

- TimelineProvider

  Widgetのコアなエンジンになります。Widgetでは常にExtensionを実行しているのではなく、OSが（時間、日、週）単位で表示する必要があるイベントのTimelineを一度に提供します。

  Timeline作成には、ますTimelineEntryを定義します。

  - TimelineEntry:

    TimelineEntryはEntryがWidgetにいつレンダリングされるかDateを指定が必須です。そして、必要な追加情報を含めることもできます。

    ```swift
    struct Covid19CountryStatusEntry: TimelineEntry {
        public let date: Date　//いつレンダリングされるか
        public let status: Covid19CountryStatus // 追加情報（Widget内容表示に利用）
    }

    ```


  TimelineProviderプロトコルには、2つのメソッドを実装する必要あります。

  - snapshot(with context:completion:)

    ホーム画面でWidget追加時Widget選択画面にWidgetがどのように見えるか表示するためのpreview。snapshot作成時completionができるだけ早く実行されて、Widget内の情報が表示される必要があります。数秒以上かかる場合Dummyのデータを提供することがおすすめされています。

    ```swift
      func snapshot(with context: Context, completion: @escaping (Covid19CountryStatusEntry) -> ()) {
            let dummy = Covid19CountryStatus.default
            let entry = Covid19CountryStatusEntry(date: Date(), status: dummy)
            completion(entry)
        }
    ```

  - timeline(with context:completion)

    Widgetが使用する実際の情報を定義します。Timelineの役割は

    1. 表示するすべてのEntriesを持つ、Timelineインスタンスを返します。
    2. Timelineの期限切れ時間 / 次いつRefreshされるかの時間

    以下では、一つのEntryを作成し５分毎にRefreshするように指定しいます。５分毎にRefresh指定はpolicyプロパティでやります。policy(RefreshPolicy)は現在のTimelineを破棄し、新しTimeline取得するタイムも定義します。policyは以下のどちらか指定できます。　

    1. never: refreshしない、変化しない静的コンテンツを表示
    2. atEnd: Timelineの最後のEntryが表示されたとき
    3. .after(Date):  指定の時間後

    （注意：新しTimeline取得後、Widgetにすぐに反映されるとは限りません。多少時間かかります。反映されるまでの時間は、ユーザーがどれだけWidgetを見ているかが大きく影響します。）

  ```swift
  func timeline(with context: Context, completion: @escaping (Timeline<Covid19CountryStatusEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Covid19DataLoader.fetch { (result) in
            let country: Covid19CountryStatus
            switch result {
            case .success(let fetchedData):
                country = fetchedData
            case .failure:
                country = Covid19CountryStatus.default
            }
            
            let entry = Covid19CountryStatusEntry(date:currentDate, status: country)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
  ```


- PlaceHolder

  Widgetの一番最初のレンダリング時（まだ表示データが取得できない時）に表示されるView。`isPlaceHolder(true)`modifierを利用すると便利。そうすることでView内のTextやImageが長方形のViewに自動的に変更されます。

  ```swift
  struct PlaceholderView: View {
      var body: some View{
          CountryStatusWidgetView(country: Covid19CountryStatus.default)
              //.isPlaceholder(true)  //Xcode12betaで試してみましたが　`Value of type XXX　has no member isPlaceholder`とエラーになりました。
      }
  }

  ```

- Content Closure

   Widgetに表示するためのSwiftUI Viewを持つClosure。ProviderからTimelineEntryを渡し、Widgetのをレンダリングします。

#### Widgetにコンテンツを表示する

WidgetはSwiftUIのViewを利用します。WidgetのConfigurationには、WidgetのコンテンツをレンダリングするためにWidgetKitが呼び出すクロージャーが含まれています。

```Swift
struct Covid19CountryStatusEntryView: View {
    var entry: Covid19CountryStatusProvider.Entry
    
    var body: some View{
        CountryStatusWidgetView(status: entry.country)
    }
}
```

#####  WidgetのSize別に違うLayoutを表示する

WidgetのSize別に違うLayoutを表示するために、@Environment Property Wrapper に新しく追加された(\.widgetFamily)を利用きます。WidgetのSizeによってViewの型の違うため@ViewBuilderの定義も必要です。

```swift
struct Covid19CountryStatusEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Covid19CountryStatusProvider.Entry
    
    @ViewBuilder
    var body: some View{
        switch family {
        case .systemSmall:
            CountryStatusWidgetView(status: entry.status)
        default:
            CountryStatusWidgetMediumView(status: entry.status)
        }
    }
}
```

##### 特定のWidget Familyのみサポート

特定のWidget Familyのみサポートするためには、.supportedFamilies modifierを利用します。

```swift
public var body: some WidgetConfiguration {
     StaticConfiguration(kind: kind,
        ...省略...
      ）
      .supportedFamilies([.systemSmall, .systemMedium]) // 追加
      .configurationDisplayName("Covid19 Tracker")
      .description("Shows Latest Information About Covid 19")
                         
                         
}
```

##### Deeplink

ユーザがWidgetをタップした時、WidgetKitがアプリを開き、指定のURLを渡すことができます。URLの指定はViewに.widgetURL modifier利用することでできます。

```swift
struct EmojiRangerWidgetEntryView: View {
    ...省略...
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
           AvatarView(entry.character)
          		.widgetURL(entry.url) // Widgetタップ時、指定の画面を開きます
        ...省略...
    }
}
```



#### Adding UserConfigurable Properties(ユーザー設定可能なプロパティ)

ユーザー設定可能なプロパティを追加するためは、SiriとShortcutを利用する際に
活用されていた技術と同じSiriKit Intent Definitionを利用します。今回はユーザにどの国の情報を表示するか選択できるようにしたいと思います。

具体的には以下のように変更します。

-  新しSiriKit Intent Definitionを追加し、プロパティの追加
- IntentTimelineProviderを準拠指定いるオブジェクトを作る
- WidgetのConfigirationをIntentConfigurationに変更する

##### 新しSiriKit Intent Definitionを追加し、プロパティの追加

File > New File > select SiriKit Intent Definition Fileを追加します。

![countryselectintent](countryselectintent.png)

新しいCustom Intentを追加後

1. CategoryはViewを選択している
2. Intent is eligible for widgetがチェックされていることを確認してます。

そして、ユーザ設定可能なプロパティとしてCountryというEnum型を設定しました。Enumの追加はEditorの右下の`+`ボタンからできます。

![addenum](addenum.png)

![countryenum](countryenum.png)



##### IntentTimelineProviderを準拠指定いるオブジェクトを作る

ProviderはIntentTimelineProviderを利用します。

```swift
struct Covid19CountryStatusIntentProvider: IntentTimelineProvider {
    typealias Entry = Covid19CountryStatusEntry
    typealias Intent = CountrySelectIntent
    
  ///　Intentに設定されたOptionを文字列に変換するhelper method
    func country(for configuration: CountrySelectIntent) -> String {
        switch configuration.country {
        
        case .unknown, .japan:
            return "jap"
        case .usa:
            return "usa"
        case .korea:
            return "kor"
        case .china:
            return "chi"
        }
    }
    
    func snapshot(for configuration: CountrySelectIntent, with context: Context, completion: @escaping (Covid19CountryStatusEntry) -> ()) {
        let dummy = Covid19CountryStatus.default
        let entry = Covid19CountryStatusEntry(date: Date(), status: dummy)
        completion(entry)
    }
    
    func timeline(for configuration: CountrySelectIntent, with context: Context, completion: @escaping (Timeline<Covid19CountryStatusEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        let selectedCountry = country(for: configuration)
        
        Covid19DataLoader.fetch(by: selectedCountry) { (result) in
            let country: Covid19CountryStatus
            switch result {
            case .success(let fetchedData):
                country = fetchedData
            case .failure:
                country = Covid19CountryStatus.default
            }
            
            let entry = Covid19CountryStatusEntry(date:currentDate, status: country)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
}
```

1. INIntent型の新しいassociatetype(CountrySelectIntent)
2. snapshot()timeline()に新し引数 `for configuration: CountrySelectIntent`

が追加されていることが確認できます。CountrySelectIntentは上で定義したCustom Intentでユーザ設定可能なプロパティ(Enum)をアクセルするためには`configuration.country`でアクセスします。

##### WidgetのConfigirationをIntentConfigurationに変更する

```Swift
@main
struct Covid19TrackerWidget: Widget {
    private let kind: String = "Covid19TrackerWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: CountrySelectIntent.self,
                            provider: Covid19CountryStatusIntentProvider(),
                            placeholder: PlaceholderView())
        { entry in
            Covid19CountryStatusEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Covid19 Tracker")
        .description("Shows Latest Information About Covid 19")
    }
}
```

WidgetのConfigirationをIntentConfigurationにします。

1. Intent引数には同じCustomIntent(CountrySelectIntent.self)を渡します。
2. ProviderはIntentTimelineProviderを準拠しているオブジェクトを渡す

![editWidget](editWidget.png)

これで実行して、Widgetを長押ししてみると`Edit Wiget`が選択できるようになります。

![userconfigurableproperty](userconfigurableproperty.png)

そして、`Edit Wiget` を選択すると国が選択できるようになります。

#### Preview

CanvasにPreviewの表示するためにはpreviewContext ModifierでWidgetPreviewContextを渡す必要あります。

`WidgetPreviewContext(family:WidgetFamily)`

```swift
struct Covid19TrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        Covid19CountryStatusEntryView(entry: Covid19CountryStatusEntry(date:Date(),status: Covid19CountryStatus.default))
                .previewContext(WidgetPreviewContext(family: .systemSmall)))
    }
}
```

#### 
