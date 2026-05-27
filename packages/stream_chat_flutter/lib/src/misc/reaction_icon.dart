import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template reactionIconBuilder}
/// Signature for a function that builds a reaction icon.
/// {@endtemplate}
typedef ReactionIconBuilder = Widget Function(
  BuildContext context,
  // ignore: avoid_positional_boolean_parameters
  bool isHighlighted,
  double iconSize,
);

/// {@template reactionIconOnTap}
/// Optional override for what happens when a reaction icon is tapped in
/// the picker. When non-null, [StreamReactionPicker] invokes this
/// callback INSTEAD of the default add/remove-reaction behavior. Useful
/// for a "+" / "more" entry that should open a custom emoji picker
/// rather than emit a literal reaction.
/// {@endtemplate}
typedef ReactionIconOnTap = void Function(
  BuildContext context,
  Message message,
);

/// {@template streamReactionIcon}
/// Reaction icon data
/// {@endtemplate}
class StreamReactionIcon {
  /// {@macro streamReactionIcon}
  const StreamReactionIcon({
    required this.type,
    required this.builder,
    this.onTap,
  });

  /// Type of reaction
  final String type;

  /// {@macro reactionIconBuilder}
  final ReactionIconBuilder builder;

  /// {@macro reactionIconOnTap}
  final ReactionIconOnTap? onTap;
}
