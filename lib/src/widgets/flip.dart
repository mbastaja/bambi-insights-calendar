import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Flip extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final String? pdfUrl;
  final DateTime? date;
  const Flip({
    required this.firstChild,
    required this.secondChild,
    this.pdfUrl,
    this.date,
    super.key,
  });

  @override
  State<Flip> createState() => _FlipState();
}

class _FlipState extends State<Flip> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  bool isHovered = false;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  Future<void> _showSimpleDialog() async {
    if (widget.pdfUrl != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                width: 800,
                height: 1000,
                child: SfPdfViewer.network(
                  widget.pdfUrl!,
                  controller: _pdfViewerController,
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(2, 1, 0.0015)
        ..rotateY(pi * _animation.value),
      child: InkWell(
        onTap: () {
          if (_status == AnimationStatus.dismissed && widget.date!.isBefore(DateTime.now())) {
            _controller.forward();
            _showSimpleDialog();
          } else {
            _controller.reverse();
          }
        },
        child: _animation.value <= 0.5
            ? MouseRegion(
                onEnter: (event) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: isHovered ? Matrix4.translationValues(4, 4, 20) : Matrix4.identity(),
                  decoration: BoxDecoration(
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12.0,
                              spreadRadius: 10.0,
                            ),
                          ]
                        : [],
                  ),
                  child: widget.firstChild,
                ),
              )
            : MouseRegion(
                onEnter: (event) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: isHovered ? Matrix4.translationValues(-4, 4, 20) : Matrix4.identity(),
                  decoration: BoxDecoration(
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12.0,
                              spreadRadius: 10.0,
                            ),
                          ]
                        : [],
                  ),
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: widget.secondChild,
                  ),
                ),
              ),
      ),
    );
  }
}
