import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read More Text App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Read More Text'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ExpandableText(
            'aaaaaaaaaaaaaaaaa\nbbbbbbbbbbbbbb\nccccccccccccccc\ndddddddddddddddd\neeeeeeeeeeee'),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 2,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final String ellipsizeText = '...';
  final String readMoreText = ' もっと見る';
  final String readLessText = ' 閉じる';
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapReadMoreOrLess() {
    setState(() => _readMore = !_readMore);
  }

  final colorClickableText = Color(0xFF00ADFE);
  final textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    final readMoreOrLess = TextSpan(
      text: _readMore ? widget.readMoreText : widget.readLessText,
      style: TextStyle(color: colorClickableText),
      recognizer: TapGestureRecognizer()..onTap = _onTapReadMoreOrLess,
    );
    final ellipsizeText = TextSpan(
      text: widget.ellipsizeText,
      style: DefaultTextStyle.of(context).style,
    );
    final textSp = TextSpan(
      text: widget.text,
      style: DefaultTextStyle.of(context).style,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);

        final textPainter = TextPainter(
          text: readMoreOrLess,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
        )..layout(
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
          );
        final readMoreTextSize = textPainter.size;

        textPainter.text = textSp;
        textPainter.layout(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );
        final textSize = textPainter.size;

        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - readMoreTextSize.width,
          textSize.height,
        ));
        final endIndex = textPainter.getOffsetBefore(pos.offset);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex + 1)
                : widget.text,
            style: DefaultTextStyle.of(context).style,
            children: _readMore
                ? <TextSpan>[
                    ellipsizeText,
                    readMoreOrLess,
                  ]
                : <TextSpan>[
                    readMoreOrLess,
                  ],
          );
        } else {
          textSpan = textSpan = TextSpan(
            text: widget.text,
            style: DefaultTextStyle.of(context).style,
          );
        }

        return RichText(
          text: textSpan,
          overflow: TextOverflow.ellipsis,
          maxLines: _readMore ? widget.trimLines : null,
        );
      },
    );
  }
}
