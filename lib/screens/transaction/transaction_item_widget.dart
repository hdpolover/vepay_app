import 'package:flutter/material.dart';

class TransactionItemWidget extends StatefulWidget {
  TransactionItemWidget({Key? key}) : super(key: key);

  @override
  State<TransactionItemWidget> createState() => _TransactionItemWidgetState();
}

class _TransactionItemWidgetState extends State<TransactionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.greenAccent[100],
      child: SizedBox(
        width: 300,
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[500],
                radius: 108,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.geeksforgeeks.org/wp-content/uploads/20210101144014/gfglogo.png"), //NetworkImage
                  radius: 100,
                ), //CircleAvatar
              ), //CircleAvatar
              const SizedBox(
                height: 10,
              ), //SizedBox
              Text(
                'GeeksforGeeks',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green[900],
                  fontWeight: FontWeight.w500,
                ), //Textstyle
              ), //Text
              const SizedBox(
                height: 10,
              ), //SizedBox
              const Text(
                'GeeksforGeeks is a computer science portal for geeks at geeksforgeeks.org. It contains well written, well thought and well explained computer science and programming articles, quizzes, projects, interview experiences and much more!!',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ), //Textstyle
              ), //Text
              const SizedBox(
                height: 10,
              ), //SizedBox
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () => 'Null',
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: const [Icon(Icons.touch_app), Text('Visit')],
                    ),
                  ),
                ),
              ) //SizedBox
            ],
          ), //Column
        ), //Padding
      ), //SizedBox
    );
  }
}
