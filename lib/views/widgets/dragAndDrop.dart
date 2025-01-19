import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DragAndDrop extends StatelessWidget {
  final VoidCallback onTap;
  final Uint8List? webImage;
  final String text;
  final num width;

  const DragAndDrop({
    required this.onTap,
    required this.webImage,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(5),
        padding: EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            color: Colors.grey[300],
            child: webImage != null
                ? Image.memory(
                    webImage!,
                    height: size.height * 0.20,
                    width: size.width * width, // 0.425,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return const Center(
                        child: Text('Error loading image'),
                      );
                    },
                  )
                : Container(
                    height: size.height * 0.20,
                    width: size.width * width,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(49, 54, 55, 1)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/Vector.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        const Text(
                          "Select Files",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(137, 136, 136, 1),
                            height: 19 / 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          text,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(137, 136, 136, 1),
                            height: 19 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
