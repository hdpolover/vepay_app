import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  String emptyTitle;
  String emptyDesc;

  EmptyWidget({required this.emptyTitle, required this.emptyDesc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: MediaQuery.of(context).size.width * 0.4,
              image: const AssetImage('assets/sorry.png'),
            ),
            const SizedBox(height: 20),
            Text(
              emptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              emptyDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
