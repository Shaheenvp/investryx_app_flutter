import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:math';
import 'chat_screen_components.dart';


enum AudioPlaybackState {
  idle,
  loading,
  playing,
  paused,
  error
}


class VoiceMessageBubble extends StatefulWidget {
  final bool isFromUser;
  final String time;
  final Duration duration;
  final VoidCallback onPlayPressed;
  final bool isPlaying;
  final String? audioPath;

  const VoiceMessageBubble({
    Key? key,
    required this.isFromUser,
    required this.time,
    required this.duration,
    required this.onPlayPressed,
    required this.isPlaying,
    this.audioPath,
  }) : super(key: key);

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _playbackController;
  late Animation<double> _playbackProgress;
  AudioPlaybackState _playbackState = AudioPlaybackState.idle;
  List<double> _waveformData = [];
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _generateWaveformData();
    if (widget.isPlaying) {
      _startPlayback();
    }
  }

  void _initializeController() {
    _playbackController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _playbackProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _playbackController,
        curve: Curves.linear,
      ),
    );

    _playbackController.addListener(() {
      if (mounted) setState(() {});
    });

    _playbackController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _playbackState = AudioPlaybackState.idle);
      }
    });
  }

  void _generateWaveformData() {
    try {
      _waveformData = List.generate(
        25, // Reduced number of bars
            (index) => 0.2 + (0.6 * index / 25) + (Random().nextDouble() * 0.2),
      );
    } catch (e) {
      debugPrint('Error generating waveform data: $e');
      _waveformData = List.filled(25, 0.5);
    }
  }

  void _startPlayback() {
    _playbackController.forward(from: 0.0);
    setState(() => _playbackState = AudioPlaybackState.playing);
    _startProgressTimer();
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) setState(() {});
    });
  }

  void _stopPlayback() {
    _playbackController.stop();
    _progressTimer?.cancel();
    setState(() => _playbackState = AudioPlaybackState.idle);
  }

  @override
  void didUpdateWidget(VoiceMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _startPlayback() : _stopPlayback();
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _playbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Align(
        alignment: widget.isFromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            minWidth: MediaQuery.of(context).size.width * 0.35,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isFromUser
                ? ChatColors.primaryLight.withOpacity(0.9)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(widget.isFromUser ? 16 : 0),
              bottomRight: Radius.circular(widget.isFromUser ? 0 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayButton(),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWaveform(),
                    const SizedBox(height: 2),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return SizedBox(
      height: 35.h,
      child: CustomPaint(
        painter: WaveformPainter(
          progress: _playbackProgress.value,
          activeColor: widget.isFromUser
              ? Colors.white
              : ChatColors.primary,
          inactiveColor: widget.isFromUser
              ? Colors.white
              : ChatColors.primary.withOpacity(0.3),
          isPlaying: widget.isPlaying,
          waveformData: _waveformData,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: widget.isFromUser
            ? Colors.white.withOpacity(0.2)
            : ChatColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPlayPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildPlayButtonIcon(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButtonIcon() {
    final color = widget.isFromUser ? Colors.white : ChatColors.primary;
    final size = 18.0; // Reduced icon size

    switch (_playbackState) {
      case AudioPlaybackState.playing:
        return Icon(Icons.pause_rounded, color: color, size: size);
      case AudioPlaybackState.loading:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      case AudioPlaybackState.error:
        return Icon(Icons.error_outline_rounded, color: Colors.red[400], size: size);
      default:
        return Icon(Icons.play_arrow_rounded, color: color, size: size);
    }
  }

  Widget _buildFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatDuration(widget.duration),
          style: TextStyle(
            fontSize: 11,
            color: widget.isFromUser
                ? Colors.white.withOpacity(0.7)
                : Colors.black45,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.mic,
          size: 12,
          color: widget.isFromUser
              ? Colors.white.withOpacity(0.7)
              : Colors.black45,
        ),
        const Spacer(),
        Text(
          _formatDateTime(widget.time),
          style: TextStyle(
            fontSize: 11,
            color: widget.isFromUser
                ? Colors.white.withOpacity(0.7)
                : Colors.black45,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return '';
    }
  }
}


class WaveformPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final bool isPlaying;
  final List<double> waveformData;

  WaveformPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.isPlaying,
    required this.waveformData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final width = size.width;
    final height = size.height;
    final barWidth = (width / waveformData.length).clamp(2.0, 4.0);
    final barGap = 2.0;

    for (var i = 0; i < waveformData.length; i++) {
      final x = i * (barWidth + barGap);
      if (x > width) break;  // Don't draw beyond the canvas width

      final amplitude = waveformData[i].clamp(0.1, 1.0);
      final barHeight = amplitude * height * 0.7;  // 70% of height maximum
      final startY = (height - barHeight) / 2;
      final endY = startY + barHeight;

      final normalized = x / width;
      final paint = normalized <= progress ? activePaint : inactivePaint;

      canvas.drawLine(
        Offset(x + barWidth / 2, startY),
        Offset(x + barWidth / 2, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) =>
      progress != oldDelegate.progress ||
          isPlaying != oldDelegate.isPlaying;
}


class VoiceRecordingOverlay extends StatefulWidget {
  final bool isRecording;
  final Duration duration;
  final VoidCallback onCancel;
  final bool isDraggingToCancel;

  const VoiceRecordingOverlay({
    Key? key,
    required this.isRecording,
    required this.duration,
    required this.onCancel,
    required this.isDraggingToCancel,
  }) : super(key: key);

  @override
  State<VoiceRecordingOverlay> createState() => _VoiceRecordingOverlayState();
}

class _VoiceRecordingOverlayState extends State<VoiceRecordingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRecordingIndicator(),
          const SizedBox(width: 16),
          _buildDurationDisplay(),
          const Spacer(),
          _buildCancelHint(),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24 * _pulseAnimation.value,
              height: 24 * _pulseAnimation.value,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDurationDisplay() {
    return Text(
      _formatDuration(widget.duration),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCancelHint() {
    return Opacity(
      opacity: widget.isDraggingToCancel ? 0.3 : 1.0,
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            'Slide to cancel',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}


class VoiceMessageHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, Duration> _audioPositions = {};
  final Map<String, List<double>> _waveformCache = {};
  bool _isPlaying = false;
  String? _currentPath;
  bool _isLoading = false;
  Timer? _progressTimer;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerPositionSubscription;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentRecordingPath;
  Duration? _pausedPosition;


  // Callbacks
  void Function(Duration)? onProgressUpdate;
  VoidCallback? onPlayComplete;
  VoidCallback? onPlayError;
  VoidCallback? onLoadStart;
  VoidCallback? onLoadComplete;
  void Function(List<double>)? onWaveformGenerated;

  Future<void> initialize() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _playerStateSubscription = _audioPlayer.onPlayerComplete.listen((_) async {
      _isPlaying = false;
      _currentPath = null;
      _pausedPosition = null;
      onPlayComplete?.call();
      _stopProgressTimer();
      await HapticFeedback.lightImpact();
    });

    _playerPositionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (_currentPath != null) {
        _audioPositions[_currentPath!] = position;
        onProgressUpdate?.call(position);
      }
    });
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentPath != null && _isPlaying) {
        onProgressUpdate?.call(_audioPositions[_currentPath!] ?? Duration.zero);
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  Future<List<double>> generateWaveformData(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      final bytes = await file.readAsBytes();
      const chunkSize = 1024;
      final amplitudes = <double>[];

      for (var i = 0; i < bytes.length; i += chunkSize) {
        final chunk = bytes.sublist(i, min(i + chunkSize, bytes.length));
        double sum = 0;
        for (final byte in chunk) {
          sum += byte.abs();
        }
        final amplitude = sum / chunk.length;
        amplitudes.add(amplitude / 255); // Normalize to 0-1 range
      }

      // Resample to get 50 data points
      final resampled = _resampleWaveform(amplitudes, 50);
      return resampled;
    } catch (e) {
      print('Error generating waveform data: $e');
      return List.generate(50, (index) => Random().nextDouble() * 0.8 + 0.2);
    }
  }

  List<double> _resampleWaveform(List<double> original, int targetLength) {
    if (original.isEmpty) return List.filled(targetLength, 0.0);
    if (original.length == targetLength) return original;

    final result = List<double>.filled(targetLength, 0.0);
    final scale = original.length / targetLength;

    for (var i = 0; i < targetLength; i++) {
      final originalIndex = (i * scale).floor();
      result[i] = original[originalIndex];
    }

    return result;
  }

  Future<void> startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw Exception('Microphone permission denied');
      }

      // Single haptic feedback when recording starts
      await HapticFeedback.heavyImpact();

      final directory = await getTemporaryDirectory();
      _currentRecordingPath = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

      final config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
      );

      await _audioRecorder.start(config, path: _currentRecordingPath.toString());
      _isRecording = true;

    } catch (e) {
      print('Error starting recording: $e');
      _isRecording = false;
      await HapticFeedback.vibrate();
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (_isRecording) {
        await _audioRecorder.stop();
        _isRecording = false;

        // Single haptic feedback when recording stops
        await HapticFeedback.mediumImpact();

        if (_currentRecordingPath != null) {
          final waveformData = await generateWaveformData(_currentRecordingPath!);
          _waveformCache[_currentRecordingPath!] = waveformData;
          onWaveformGenerated?.call(waveformData);
          return _currentRecordingPath;
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording = false;
      await HapticFeedback.vibrate();
      rethrow;
    }
    return null;
  }

  Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        await _audioRecorder.stop();
        _isRecording = false;

        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }

        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      print('Error canceling recording: $e');
      await HapticFeedback.vibrate();
      rethrow;
    }
  }

  Future<void> playVoiceMessage(String audioPath) async {
    try {
      _isLoading = true;
      onLoadStart?.call();

      if (_currentPath == audioPath && _isPlaying) {
        await pausePlaying();
        return;
      }

      if (_currentPath == audioPath && _pausedPosition != null) {
        await resumePlaying();
        return;
      }

      if (_currentPath != null && _currentPath != audioPath) {
        await stopPlaying();
      }

      String? finalPath = audioPath;
      if (!audioPath.startsWith('file://')) {
        final fullUrl = AudioPathHandler.getFullAudioUrl(audioPath);

        // Try to get cached version first
        finalPath = await AudioCacheManager.getCachedPath(fullUrl);

        if (finalPath == null) {
          // If not in cache, download and cache
          finalPath = await AudioCacheManager.cacheAudio(fullUrl);
          if (finalPath == null) {
            throw Exception('Failed to cache audio file');
          }
        }
      }

      await HapticFeedback.lightImpact();

      // Set audio source
      await _audioPlayer.setSourceDeviceFile(finalPath);

      // Generate and cache waveform if needed
      if (!_waveformCache.containsKey(audioPath)) {
        final waveformData = await generateWaveformData(finalPath);
        _waveformCache[audioPath] = waveformData;
        onWaveformGenerated?.call(waveformData);
      }

      await _audioPlayer.resume();
      _isPlaying = true;
      _currentPath = audioPath;
      _startProgressTimer();

    } catch (e) {
      debugPrint('Error playing voice message: $e');
      _isPlaying = false;
      _currentPath = null;
      _pausedPosition = null;
      onPlayError?.call();
      await HapticFeedback.vibrate();
      rethrow;
    } finally {
      _isLoading = false;
      onLoadComplete?.call();
    }
  }

  Future<void> pausePlaying() async {
    try {
      // Store current position before pausing
      _pausedPosition = await _audioPlayer.getCurrentPosition() ?? Duration.zero;
      await _audioPlayer.pause();
      _isPlaying = false;
      _stopProgressTimer();
      await HapticFeedback.lightImpact();
    } catch (e) {
      print('Error pausing playback: $e');
      await HapticFeedback.vibrate();
      rethrow;
    }
  }

  Future<void> resumePlaying() async {
    try {
      if (_pausedPosition != null) {
        // Seek to the paused position before resuming
        await _audioPlayer.seek(_pausedPosition!);
      }
      await _audioPlayer.resume();
      _isPlaying = true;
      _startProgressTimer();
      await HapticFeedback.lightImpact();
    } catch (e) {
      print('Error resuming playback: $e');
      await HapticFeedback.vibrate();
      rethrow;
    }
  }

  Future<void> stopPlaying() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        _isPlaying = false;
        _currentPath = null;
        _pausedPosition = null;
        _stopProgressTimer();
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      print('Error stopping playback: $e');
      await HapticFeedback.vibrate();
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      await stopPlaying();
      await _audioPlayer.dispose();
      _playerStateSubscription?.cancel();
      _playerPositionSubscription?.cancel();
      _stopProgressTimer();
      _pausedPosition = null;
      _audioPositions.clear();
      _waveformCache.clear();
      await AudioCacheManager.clearCache();
    } catch (e) {
      debugPrint('Error disposing audio handler: $e');
    }
  }

  Duration? get pausedPosition => _pausedPosition;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  String? get currentPath => _currentPath;
  Duration getPosition(String path) => _audioPositions[path] ?? Duration.zero;
}

class AudioPathHandler {
  static String getFullAudioUrl(String path) {
    const baseUrl = 'https://investryx.com';
    if (path.startsWith('http')) {
      return path;
    }
    return '$baseUrl$path';
  }

  static Future<bool> checkAudioAvailability(String url) async {
    try {
      final response = await HttpClient()
          .getUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 5))
          .then((request) => request.close());
      return response.statusCode == 200;
    } catch (e) {
      print('Audio availability check failed: $e');
      return false;
    }
  }
}

class VoiceRecordingButton extends StatefulWidget {
  final VoidCallback onVoiceMessageStart;
  final VoidCallback onVoiceMessageEnd;
  final VoidCallback onVoiceMessageCancel;
  final bool isRecording;

  const VoiceRecordingButton({
    Key? key,
    required this.onVoiceMessageStart,
    required this.onVoiceMessageEnd,
    required this.onVoiceMessageCancel,
    required this.isRecording,
  }) : super(key: key);

  @override
  State<VoiceRecordingButton> createState() => _VoiceRecordingButtonState();
}

class _VoiceRecordingButtonState extends State<VoiceRecordingButton> {
  bool _isDraggingToCancel = false;
  Offset _dragStartPosition = Offset.zero;
  bool _showCancelHint = false;

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _dragStartPosition = details.globalPosition;
      _isDraggingToCancel = false;
      _showCancelHint = true;
    });
    widget.onVoiceMessageStart();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.isRecording) return;

    final dragOffset = details.globalPosition - _dragStartPosition;
    final isDraggingUp = dragOffset.dy < -50;
    final isDraggingLeft = dragOffset.dx < -50;

    if (_isDraggingToCancel != (isDraggingUp || isDraggingLeft)) {
      setState(() {
        _isDraggingToCancel = isDraggingUp || isDraggingLeft;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isDraggingToCancel) {
      widget.onVoiceMessageCancel();
    } else {
      widget.onVoiceMessageEnd();
    }
    setState(() {
      _isDraggingToCancel = false;
      _showCancelHint = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_showCancelHint)
          Positioned(
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isDraggingToCancel ? 'Release to cancel' : 'Slide up to cancel',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        GestureDetector(
          onVerticalDragStart: _handleDragStart,
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          onHorizontalDragStart: _handleDragStart,
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getButtonColor(),
              boxShadow: [
                if (!widget.isRecording)
                  BoxShadow(
                    color: ChatColors.primary.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              _getButtonIcon(),
              color: _getIconColor(),
              size: 20,
            ),
          ),
        ),
        if (widget.isRecording)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: _isDraggingToCancel ? 100 : 60,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isDraggingToCancel ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isDraggingToCancel ? Icons.close : Icons.mic,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Color _getButtonColor() {
    if (widget.isRecording) {
      if (_isDraggingToCancel) {
        return Colors.red.withOpacity(0.1);
      }
      return Colors.red;
    }
    return ChatColors.primary;
  }

  Color _getIconColor() {
    if (widget.isRecording) {
      return _isDraggingToCancel ? Colors.red : Colors.white;
    }
    return Colors.white;
  }

  IconData _getButtonIcon() {
    if (widget.isRecording) {
      return _isDraggingToCancel ? Icons.close : Icons.mic;
    }
    return Icons.mic_none;
  }
}

class AudioCacheManager {
  static final Map<String, File> _audioCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(days: 7); // Cache duration

  static Future<String?> getCachedPath(String url) async {
    final cacheKey = _generateCacheKey(url);
    final cachedFile = _audioCache[cacheKey];
    final timestamp = _cacheTimestamps[cacheKey];

    if (cachedFile != null && timestamp != null) {
      if (DateTime.now().difference(timestamp) < _cacheDuration && await cachedFile.exists()) {
        return cachedFile.path;
      } else {
        // Remove expired cache
        await cachedFile.delete();
        _audioCache.remove(cacheKey);
        _cacheTimestamps.remove(cacheKey);
      }
    }
    return null;
  }

  static Future<String?> cacheAudio(String url) async {
    try {
      final cacheKey = _generateCacheKey(url);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$cacheKey.m4a');

      // Download and cache the file
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != 200) return null;

      await response.pipe(file.openWrite());

      _audioCache[cacheKey] = file;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return file.path;
    } catch (e) {
      debugPrint('Error caching audio: $e');
      return null;
    }
  }

  static String _generateCacheKey(String url) {
    return url.split('/').last;
  }

  static Future<void> clearCache() async {
    try {
      for (var file in _audioCache.values) {
        if (await file.exists()) {
          await file.delete();
        }
      }
      _audioCache.clear();
      _cacheTimestamps.clear();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}