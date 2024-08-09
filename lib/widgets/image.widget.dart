import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    this.imageUrl,
    this.errorText,
    this.radius,
    this.width,
    this.height,
    this.errorTextFontSize,
  }) : super(key: key);

  final String imageUrl;
  final String errorText;
  final double radius;
  final double width;
  final double height;
  final double errorTextFontSize;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && !imageUrl.contains("null") && imageUrl.length > 0
        ? Container(
            decoration: BoxDecoration(
              color: Color(0x334F62C0),
              borderRadius: BorderRadius.circular(radius ?? 45),
              border: Border.all(
                width: 3,
                color: Color(0x334F62C0),
              ),
            ),
            child: Container(
              child: CachedNetworkImage(
                height: width != null ? (width) : 50,
                width: height != null ? (height) : 50,
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius ?? 50),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: width ?? 50,
                  width: height ?? 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x80839daf),
                  ),
                  child: Center(
                    child: Text(
                      errorText,
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontSize: errorTextFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                width: 3,
                color: Color(0x334F62C0),
              ),
            ),
            child: Container(
              height: width ?? 45,
              width: height ?? 45,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff7e9caf),
              ),
              child: Center(
                child: Text(
                  errorText ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: errorTextFontSize,
                  ),
                ),
              ),
            ),
          );
  }
}
