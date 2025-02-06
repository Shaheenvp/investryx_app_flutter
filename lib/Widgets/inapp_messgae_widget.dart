import 'package:flutter/material.dart';
import 'dart:ui';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static OverlayEntry? _overlayEntry;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get _context => navigatorKey.currentContext;

  void showNotification({
    required String senderName,
    required String message,
    String? senderImage,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? textColor,
    NotificationPosition position = NotificationPosition.top,
  }) {
    final context = _context;
    if (context == null) {
      debugPrint('Context is null');
      return;
    }

    if (_overlayEntry?.mounted == true) {
      try {
        _overlayEntry?.remove();
      } catch (e) {
        debugPrint('Error removing existing overlay: $e');
      }
    }
    _overlayEntry = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final overlay = Overlay.of(context, rootOverlay: true);
        if (overlay == null) {
          debugPrint('Overlay is null');
          return;
        }

        _overlayEntry = OverlayEntry(
          builder: (context) => Stack(
            children: [
              CompactMessageNotification(
                senderName: senderName,
                message: message,
                senderImage: senderImage,
                onTap: () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  onTap?.call();
                },
                backgroundColor: backgroundColor,
                textColor: textColor,
                position: position,
              ),
            ],
          ),
        );

        overlay.insert(_overlayEntry!);

        Future.delayed(const Duration(seconds: 4), () {
          if (_overlayEntry?.mounted == true) {
            _overlayEntry?.remove();
            _overlayEntry = null;
          }
        });
      } catch (e) {
        debugPrint('Error showing notification: $e');
      }
    });
  }
}

enum NotificationPosition { top, bottom }

class CompactMessageNotification extends StatefulWidget {
  final String senderName;
  final String message;
  final String? senderImage;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final NotificationPosition position;

  const CompactMessageNotification({
    Key? key,
    required this.senderName,
    required this.message,
    this.senderImage,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.position = NotificationPosition.top,
  }) : super(key: key);

  @override
  State<CompactMessageNotification> createState() => _CompactMessageNotificationState();
}

class _CompactMessageNotificationState extends State<CompactMessageNotification> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Faster animation
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, widget.position == NotificationPosition.top ? -1.0 : 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo, // More modern easing
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1A1A1A) // Darker background for dark mode
        : const Color(0xFFFAFAFA); // Lighter background for light mode

    return Stack(
      children: [
        Positioned(
          top: widget.position == NotificationPosition.top
              ? MediaQuery.of(context).padding.top + 16
              : null,
          bottom: widget.position == NotificationPosition.bottom
              ? MediaQuery.of(context).padding.bottom + 16
              : null,
          left: 16,
          right: 16,
          child: SafeArea(
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.up,
                  onDismissed: (_) => widget.onTap?.call(),
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? defaultBackgroundColor,
                        borderRadius: BorderRadius.circular(16), // Larger radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (widget.backgroundColor ?? defaultBackgroundColor)
                                  .withOpacity(0.8),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.senderImage != null) ...[
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.black.withOpacity(0.05),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 20, // Slightly larger
                                        backgroundImage: NetworkImage(widget.senderImage!),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.senderName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700, // Bolder
                                            fontSize: 16, // Slightly larger
                                            color: widget.textColor ??
                                                Theme.of(context).textTheme.titleMedium?.color,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.message,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14, // Slightly larger
                                            color: widget.textColor?.withOpacity(0.8) ??
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.8),
                                            height: 1.4,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: widget.textColor?.withOpacity(0.5) ??
                                          Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}