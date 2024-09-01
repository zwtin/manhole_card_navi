import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetail extends StatefulWidget {
  const ImageDetail({
    super.key,
    required this.imageUrl,
    required this.imageTag,
  });

  final String imageUrl;
  final String imageTag;

  @override
  ImageDetailViewState createState() => ImageDetailViewState();
}

class ImageDetailViewState extends State<ImageDetail> {
  Offset beginningDragPosition = Offset.zero;
  Offset currentDragPosition = Offset.zero;
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  int photoViewAnimationDurationMilliSec = 0;
  double barsOpacity = 1;

  double get photoViewScale {
    return max(1.0 - currentDragPosition.distance * 0.001, 0.8);
  }

  double get photoViewOpacity {
    return max(1.0 - currentDragPosition.distance * 0.005, 0.1);
  }

  Matrix4 get photoViewTransform {
    final translationTransform = Matrix4.translationValues(
      currentDragPosition.dx,
      currentDragPosition.dy,
      0,
    );

    final scaleTransform = Matrix4.diagonal3Values(
      photoViewScale,
      photoViewScale,
      1,
    );

    return translationTransform * scaleTransform as Matrix4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildImage(context),
          _buildTopBar(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: onTapPhotoView,
      onVerticalDragStart: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragStart
          : null,
      onVerticalDragUpdate: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragUpdate
          : null,
      onVerticalDragEnd:
          scaleState == PhotoViewScaleState.initial ? onVerticalDragEnd : null,
      onHorizontalDragStart: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragStart
          : null,
      onHorizontalDragUpdate: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragUpdate
          : null,
      onHorizontalDragEnd:
          scaleState == PhotoViewScaleState.initial ? onVerticalDragEnd : null,
      child: Container(
        color: Colors.black.withOpacity(photoViewOpacity),
        child: AnimatedContainer(
          duration: Duration(milliseconds: photoViewAnimationDurationMilliSec),
          transform: photoViewTransform,
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            imageProvider: CachedNetworkImageProvider(widget.imageUrl),
            heroAttributes: PhotoViewHeroAttributes(
                tag: widget.imageTag, transitionOnUserGestures: true),
            minScale: PhotoViewComputedScale.contained,
            scaleStateChangedCallback: (state) {
              setState(() {
                scaleState = state;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const topBarHeight = 108.0;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: barsOpacity,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        height: topBarHeight,
        child: Column(
          children: [
            Container(height: statusBarHeight),
            SizedBox(
              height: topBarHeight - statusBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapPhotoView() {
    setState(() {
      barsOpacity = (barsOpacity <= 0.0) ? 1.0 : 0.0;
    });
  }

  void onVerticalDragStart(DragStartDetails details) {
    setState(() {
      barsOpacity = 0.0;
      photoViewAnimationDurationMilliSec = 0;
    });
    beginningDragPosition = details.globalPosition;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      barsOpacity = (currentDragPosition.distance < 20.0) ? 1.0 : 0.0;
      currentDragPosition = Offset(
        details.globalPosition.dx - beginningDragPosition.dx,
        details.globalPosition.dy - beginningDragPosition.dy,
      );
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (currentDragPosition.distance < 100.0) {
      setState(() {
        photoViewAnimationDurationMilliSec = 200;
        currentDragPosition = Offset.zero;
        barsOpacity = 1.0;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
