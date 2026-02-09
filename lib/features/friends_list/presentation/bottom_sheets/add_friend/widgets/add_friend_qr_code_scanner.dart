import 'dart:math' as math;

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/friends_list/domain/friend_code.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/bloc/add_friend_bloc.dart';
import 'package:taskify/features/friends_list/presentation/models/add_friend_state_type.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AddFriendQrCodeScanner extends StatefulWidget {
  const AddFriendQrCodeScanner({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<AddFriendQrCodeScanner> createState() =>
      _AddFriendQrCodeScannerState();
}

class _AddFriendQrCodeScannerState extends State<AddFriendQrCodeScanner> {
  final MobileScannerController _scannerController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );
  late final AppLifecycleListener _appLifecycleListener;
  bool _hasPermission = true;
  bool _isPermissionResolved = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onResume: _checkPermissionStatus,
    );
    _requestPermission();
  }

  void _onEnterCodePressed(BuildContext context) {
    context.read<AddFriendBloc>().add(
          const AddFriendSwitchMode(AddFriendStateType.textField),
        );
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    await _applyPermissionStatus(status);
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.camera.status;
    await _applyPermissionStatus(status);
  }

  Future<void> _onOpenSettingsPressed() async {
    await openAppSettings();
    await _checkPermissionStatus();
  }

  Future<void> _applyPermissionStatus(PermissionStatus status) async {
    if (!mounted) {
      return;
    }

    TalkerService.instance.info('Permission status: $status');

    setState(() {
      _hasPermission = status.isGranted;
      _isPermissionResolved = true;
      _permissionStatus = status;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) {
      return;
    }
    final barcodes = capture.barcodes;
    final barcode = barcodes.isNotEmpty ? barcodes.first : null;
    final rawValue = barcode?.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    final formatted = FriendCode.format(rawValue);
    if (!FriendCode.isValid(formatted)) {
      return;
    }

    _hasScanned = true;
    widget.controller.text = formatted;
    _scannerController.stop();
    if (mounted) {
      context.read<AddFriendBloc>().add(
            const AddFriendSwitchMode(AddFriendStateType.textField),
          );
    }
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 1.25;

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Colors.black),
                  if (_isPermissionResolved && _hasPermission)
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          controller: _scannerController,
                          onDetect: _onDetect,
                        ),
                        const _QrScannerMask(),
                      ],
                    ),
                  if (_isPermissionResolved && !_hasPermission)
                    _PermissionDeniedOverlay(
                      shouldShowOpenSettings:
                          _permissionStatus.isPermanentlyDenied,
                      onOpenSettings: _onOpenSettingsPressed,
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onEnterCodePressed(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              l10n?.enterCode ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QrScannerMask extends StatelessWidget {
  const _QrScannerMask();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrScannerMaskPainter(),
    );
  }
}

class _QrScannerMaskPainter extends CustomPainter {
  static const double _maskOpacity = 0.6;
  static const double _cutoutSize = 192;
  static const double _cutoutRadius = 32;
  static const double _minPadding = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: _maskOpacity);

    final fullRect = Offset.zero & size;
    final maxSize = math.max(0, size.shortestSide - _minPadding);
    final squareSize = math.min(_cutoutSize, maxSize);
    final squareRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: squareSize.toDouble(),
      height: squareSize.toDouble(),
    );
    final squareRRect = RRect.fromRectAndRadius(
      squareRect,
      const Radius.circular(_cutoutRadius),
    );

    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(fullRect)
      ..addRRect(squareRRect);

    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PermissionDeniedOverlay extends StatelessWidget {
  const _PermissionDeniedOverlay({
    required this.shouldShowOpenSettings,
    required this.onOpenSettings,
  });

  final bool shouldShowOpenSettings;
  final VoidCallback onOpenSettings;

  void _onOpenSettingsPressed(BuildContext context) {
    onOpenSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n?.cameraAccessRequired ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            if (shouldShowOpenSettings) ...[
              const SizedBox(height: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onOpenSettingsPressed(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      l10n?.openSettings ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
