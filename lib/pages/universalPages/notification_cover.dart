
import 'package:flutter/material.dart';

class NotificationCover extends StatefulWidget {
  final BuildContext rootContext;
  const NotificationCover({super.key, required this.rootContext});

  @override
  State<NotificationCover> createState() => _NotificationCoverState();
}

class _NotificationCoverState extends State<NotificationCover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 50,
            right: 10,
            child: GestureDetector(
              onTap: () {
                
              },
              child: Container(
                width: 280,
                height: 80,
                alignment: Alignment.topRight,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
