//import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:reminder_app/memo.dart';

//カラー定義
const mainLightBlue = Color(0xFFABD2D6);
const backgroundgry = Color(0xFFF5F5F5);

class Memo {
  String title;
  String note;
  String dateType;
  DateTime? date;
  bool isDone;
  IconData icon;

  Memo({
    required this.title,
    required this.note,
    required this.dateType,
    required this.icon,
    this.date,
    this.isDone = false,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //カラー定義
  //final mainLightBlue = Color(0xFFABD2D6);
  //final backgroundgry = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ゆるリマインダー',

      theme: ThemeData(
        appBarTheme: AppBarThemeData(
          backgroundColor: backgroundgry,
        ),

        primaryColor: Color(0xFFABD2D6),
        scaffoldBackgroundColor: Color(0xFFF5F5F5)
      ),

      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Memo> memos = [
    Memo(
      title: "気になってたカフェに行ってみる",
      dateType: "someday",
      note: "駅前",
      icon: Icons.coffee,
    ),
    Memo(
      title: "深海展",
      dateType: "thisMonth",
      note: "博物館",
      icon: Icons.museum,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
  
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(memos[index].title),

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                ),
              ),
             
            onDismissed: (direction) {
              setState(() {
                memos.removeAt(index);
              });
            },

            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ListTile(
                leading: Icon(
                  memos[index].icon,
                  color: Color(0xFF2B2B2B),),

                title: Text(
                  memos[index].title,
                  style: TextStyle(
                    decoration: memos[index].isDone
                      ? TextDecoration.lineThrough
                      : null,
                  ),
                ),

                subtitle: Text(memos[index].note),
                //style: TextStyle(fontSize: 18),
                
                trailing: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  value: memos[index].isDone,
                  activeColor: mainLightBlue,
                  checkColor: Color(0xFFFFFFFF),
                  onChanged: (value) {
                    setState(() {
                      memos[index].isDone = value!;
                    });
                  },
                ),
              ),
            ),
          );
        }
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
          size: 28,
        ),
      ),
    );
  }
}

class AddMemoPage extends StatelessWidget {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("メモ追加"),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "やりたいことを書く",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text("保存"),
            )

          ],
        ),
      ),
    );
  }
}