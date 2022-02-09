import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppSharedMethod {
  AppSharedMethod._();
  static final AppSharedMethod instance =AppSharedMethod._();
  factory AppSharedMethod() => instance;


  var urlProduct =
      "https://images.unsplash.com/photo-1613177794106-be20802b11d3?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y2xvY2slMjBoYW5kc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";

  Widget imageNetwork({double? width, double? height, String? url}) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // border: Border.all(color: colorBorderLight),
            color: const Color(0xFFF5F5F5),
            image: DecorationImage(
              image: CachedNetworkImageProvider(url.toString() ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      imageUrl: url!,
      errorWidget: (context, url, error) {
        return CachedNetworkImage(
          imageUrl: "https://umuzi-org.github.io/tech-department/projects/kotlin/project-8/loading-displaying-images/467c213c859e1904.png",
          fit: BoxFit.cover,
        );
      },
      width: width ?? 74,
      height: height ?? 74,
      fit: BoxFit.cover,
      placeholder: (context, String? url) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/loading_shimmer.gif") /* CachedNetworkImageProvider(url ?? urlUserPlacholder!)*/,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child:  Container(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                )),
          ),
        );
      },
    );
  }
}