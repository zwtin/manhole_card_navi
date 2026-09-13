import 'package:flutter/material.dart';

class DisplayLargeText extends StatelessWidget {
  const DisplayLargeText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class DisplayMediumText extends StatelessWidget {
  const DisplayMediumText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class DisplaySmallText extends StatelessWidget {
  const DisplaySmallText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class HeadlineLargeText extends StatelessWidget {
  const HeadlineLargeText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class HeadlineMediumText extends StatelessWidget {
  const HeadlineMediumText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class HeadlineSmallText extends StatelessWidget {
  const HeadlineSmallText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class TitleLargeText extends StatelessWidget {
  const TitleLargeText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class TitleMediumText extends StatelessWidget {
  const TitleMediumText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class TitleSmallText extends StatelessWidget {
  const TitleSmallText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class BodyLargeText extends StatelessWidget {
  const BodyLargeText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class BodyMediumText extends StatelessWidget {
  const BodyMediumText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class BodySmallText extends StatelessWidget {
  const BodySmallText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class LabelLargeText extends StatelessWidget {
  const LabelLargeText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class LabelMediumText extends StatelessWidget {
  const LabelMediumText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class LabelSmallText extends StatelessWidget {
  const LabelSmallText(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            overflow: overflow,
          ),
    );
  }
}

class TitleLargeLinkText extends StatelessWidget {
  const TitleLargeLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}

class TitleMediumLinkText extends StatelessWidget {
  const TitleMediumLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}

class TitleSmallLinkText extends StatelessWidget {
  const TitleSmallLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}

class BodyLargeLinkText extends StatelessWidget {
  const BodyLargeLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}

class BodyMediumLinkText extends StatelessWidget {
  const BodyMediumLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}

class BodySmallLinkText extends StatelessWidget {
  const BodySmallLinkText(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  });

  final String data;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.blue,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
    );
  }
}
