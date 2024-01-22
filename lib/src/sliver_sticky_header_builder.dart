import 'package:flutter/widgets.dart';

import 'sliver_sticky_header.dart';

class SliverStickyHeaderBuilder extends StatefulWidget {
  SliverStickyHeaderBuilder({
    Key? key,
    this.reverse = false,
    this.overlayHeader = false,
    required this.body,
    required this.builder,
  }) : super(key: key);

  /// Called when the sticky amount changes for the header.
  /// This builder must not return null.
  final StickyHeaderWidgetBuilder builder;

  /// Setting [reverse] to `true` places [header] at the opposite end of the
  /// sliver than normal. This is most useful when a [SliverStickyHeader] is
  /// above [ScrollView.center] and you want to place the header at the top.
  /// Above the center slivers grow in the opposite direction and this option
  /// counteracts this behaviour. When [reverse] is `false` (default) and
  /// [ScrollView.reverse] is `false`, headers in slivers above
  /// [ScrollView.center] appear at the bottom.
  final bool reverse;

  /// When `true` the [header] is overlaid over the [body], even when the sliver
  /// has not been scrolled. This is in contrast to the default behaviour, where
  /// the header takes up space along the scroll axis.
  final bool overlayHeader;

  /// The widget which is scrolling normally. Must be a sliver.
  final Widget body;

  @override
  State<SliverStickyHeaderBuilder> createState() =>
      _SliverStickyHeaderBuilderState();
}

class _SliverStickyHeaderBuilderState extends State<SliverStickyHeaderBuilder> {
  double? _stuckAmount;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      reverse: widget.reverse,
      overlayHeader: widget.overlayHeader,
      header: LayoutBuilder(
        builder: (context, _) => widget.builder(context, _stuckAmount ?? 0.0),
      ),
      body: widget.body,
      callback: (double stuckAmount) {
        if (_stuckAmount != stuckAmount) {
          _stuckAmount = stuckAmount;
          WidgetsBinding.instance.endOfFrame.then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      },
    );
  }
}
