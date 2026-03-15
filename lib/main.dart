//import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:reminder_app/memo.dart';

//カラー定義
const mainLightBlue = Color(0xFFABD2D6);
const backgroundgry = Color(0xFFF5F5F5);
const backgroundblue = Color(0xFFDDECEE);
const naturalbrack = Color(0xFF2B2B2B);


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ゆるリマインダー',
      theme: ThemeData(
        appBarTheme: AppBarThemeData(
          backgroundColor: backgroundgry,
        ),
        primaryColor: mainLightBlue,
        scaffoldBackgroundColor: backgroundgry
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class Memo {
  String title;
  IconData icon;
  String scheduleType;
  bool isDone;

  Memo({
    required this.title,
    required this.icon,
    required this.scheduleType,
    this.isDone = false,
  });
}

class _HomePageState extends State<HomePage> {

  List<Memo> memos = [
    Memo(
      title: "カフェ巡りする",
      icon: Icons.coffee,
      scheduleType: "今月中",
    ),
    Memo(
      title: "深海展いきたい",
      icon: Icons.museum,
      scheduleType: "あとで",
    ),
  ];

  ///週間カレンダー
  Widget buildWeekCalender() {
    final now = DateTime.now();

    List<String> weekdays = [
      "日", "月", "火", "水", "木", "金", "土"
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {

        DateTime date =
          now.subtract(Duration(days: now.weekday % 7 - index));

        bool isToday =
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;

        return Column(
          children: [
            Text(
              weekdays[index],
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 6),

            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isToday
                  ? mainLightBlue
                  : Colors.transparent,
                shape: BoxShape.circle, 
              ),
              child: Text(
                "${date.day}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      }),
    );
  }

  ///メモカードUI
  Widget buildMemoCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),

      child: Row(
        children: [
          ///アイコン
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundblue,
              shape: BoxShape.circle,
            ),
            child: Icon(memos[index].icon,
              color: naturalbrack,
            ),
          ),
          
          SizedBox(width: 12),

          ///タイトル+日付タイプ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memos[index].title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 6),

                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F1F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(memos[index].scheduleType,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5A7C88),
                    ),
                  ),
                ),
              ],
            ),
          ),

            ///チェックボックス
          Checkbox(
            shape: CircleBorder(),
            value: false,
            onChanged: (value){},
            activeColor: mainLightBlue,
            checkColor: Colors.white,
          ),
        ],
      ),
    );

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),

      body: Stack(
        children: [
          ///カレンダー(下レイヤー)
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 12),
            child: buildWeekCalender(),
          ),

          ///メモリスト(上レイヤー)
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),

                child: ListView.builder(
                  controller: scrollController,
                  itemCount: memos.length,
                  itemBuilder: (context, index) {
                    return buildMemoCard(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
  
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),

        onPressed: () async {
           
          final newNemo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMemoPage(),
            ),
          );

          if (newNemo != null) {
            setState(() {
              memos.add(newNemo);
            });
          }
        },
        // 画面遷移
        child: Icon(
          Icons.add,
          color: naturalbrack,
          size: 28,
        ),
      ),
    );
  }
}

class AddMemoPage extends StatefulWidget {
  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {

  ///タイトル入力
  TextEditingController titleController = TextEditingController();

  ///選択アイコン
  IconData selectedIcon = Icons.star;

  ///日付タイプ
  String selectedSchedule = "あとで";

  ///アイコンリスト
  List<IconData> iconOptions = [
    Icons.palette,
    Icons.menu_book,
    Icons.flight,
    Icons.coffee,
    Icons.museum,
    Icons.star,
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("メモ追加"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///タイトル入力
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "タイトル",
              ),
            ),

            SizedBox(height: 20),

            Wrap(
              spacing: 10,
              children: iconOptions.map((icon) {

                bool isSelected = icon == selectedIcon;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIcon = icon;
                    });
                  },

                  child: Container(
                    padding: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: isSelected
                        ? mainLightBlue
                        : backgroundgry,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),

                    child: Icon(
                      icon,
                      color: isSelected 
                        ? naturalbrack
                        : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30),
            
            ///保存ボタン
            Center(
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundblue,
                  foregroundColor: naturalbrack,

                  elevation: 4, //影の強さ

                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  )
                ),

                onPressed: () {

                  Memo newNemo = Memo(
                    title: titleController.text,
                    icon: selectedIcon,
                    scheduleType: selectedSchedule,
                  );

                  Navigator.pop(context, newNemo);
                },

                child: Text("保存"),
              ),
            )
          ],
        ),
      ),
    );
  }
}