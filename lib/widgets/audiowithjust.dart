// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';

// // Singleton to manage a single AudioPlayer instance
// class AudioPlayerManager {
//   static final AudioPlayerManager _instance = AudioPlayerManager._internal();
//   factory AudioPlayerManager() => _instance;
//   AudioPlayerManager._internal();

//   AudioPlayer? _currentPlayer;

//   void registerPlayer(AudioPlayer player) {
//     _currentPlayer?.stop();
//     _currentPlayer = player;
//   }

//   void stopCurrent() {
//     _currentPlayer?.stop();
//     _currentPlayer = null;
//   }
// }

// class AudioPlayerWidget extends StatefulWidget {
//   final String audioSource; // URL or local path
//   final bool isUrl; // True for URL, false for local path
//   final Color waveColor; // Waveform color
//   final Color seekLineColor; // Seek line color
//   final double waveformHeight; // Height of waveform
//   final IconData playIcon; // Custom play icon
//   final IconData pauseIcon; // Custom pause icon
//   final double iconSize; // Size of play/pause icons
//   final bool showSeekSlider; // Show/hide seek slider

//   const AudioPlayerWidget({
//     Key? key,
//     required this.audioSource,
//     this.isUrl = true,
//     this.waveColor = Colors.blue,
//     this.seekLineColor = Colors.red,
//     this.waveformHeight = 100,
//     this.playIcon = Icons.play_arrow,
//     this.pauseIcon = Icons.pause,
//     this.iconSize = 32,
//     this.showSeekSlider = true,
//   }) : super(key: key);

//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   late AudioPlayer _audioPlayer;
//   late PlayerController _playerController;
//   bool _isPlaying = false;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _playerController = PlayerController();
//     AudioPlayerManager().registerPlayer(_audioPlayer);
//     _initAudio();
//   }

//   Future<void> _initAudio() async {
//     try {
//       // Set audio source and configure no looping
//       if (widget.isUrl) {
//         await _audioPlayer.setUrl(widget.audioSource);
//       } else {
//         await _audioPlayer.setFilePath(widget.audioSource);
//       }
//       await _audioPlayer.setLoopMode(LoopMode.off); // Stop after completion

//       // Initialize waveform
//       await _playerController.preparePlayer(
//         path: widget.audioSource,
//         shouldExtractWaveform: true,
//       );

//       // Listen to audio duration changes
//       _audioPlayer.durationStream.listen((duration) {
//         if (mounted) {
//           setState(() {
//             _duration = duration ?? Duration.zero;
//           });
//         }
//       });

//       // Listen to audio position changes
//       _audioPlayer.positionStream.listen((position) {
//         if (mounted) {
//           setState(() {
//             _position = position;
//           });
//           _playerController.updateCurrentDuration(position);
//         }
//       });

//       // Sync waveform seeking with audio position
//       _playerController.onCurrentDurationChanged.listen((duration) {
//         if (!_audioPlayer.playing) {
//           _audioPlayer.seek(duration);
//         }
//       });

//       // Stop player when audio completes
//       _audioPlayer.playerStateStream.listen((state) {
//         if (state.processingState == ProcessingState.completed) {
//           AudioPlayerManager().stopCurrent();
//           _playerController.stopPlayer();
//           setState(() {
//             _isPlaying = false;
//             _position = Duration.zero;
//           });
//           _audioPlayer.seek(Duration.zero);
//         }
//       });
//     } catch (e) {
//       debugPrint("Error initializing audio: $e");
//     }
//   }

//   @override
//   void dispose() {
//     if (AudioPlayerManager()._currentPlayer == _audioPlayer) {
//       AudioPlayerManager().stopCurrent();
//     }
//     _audioPlayer.dispose();
//     _playerController.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     AudioPlayerManager().registerPlayer(_audioPlayer);
//     if (_isPlaying) {
//       _audioPlayer.pause();
//       _playerController.stopPlayer();
//     } else {
//       _audioPlayer.play();
//       _playerController.startPlayer();
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Waveform visualization
//         Container(
//           height: widget.waveformHeight,
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: AudioFileWaveforms(
//             size: Size(double.infinity, widget.waveformHeight),
//             playerController: _playerController,
//             enableSeek: true,
//             waveformType: WaveformType.long,
//             playerWaveStyle: PlayerWaveStyle(
//               scaleFactor: 0.5,
//               waveThickness: 2,
//               showSeekLine: true,
//               seekLineThickness: 2,
//               seekLineColor: widget.seekLineColor,
//               waveColor: widget.waveColor,
//             ),
//           ),
//         ),
//         // Playback controls and progress
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Play/Pause button
//               IconButton(
//                 icon: Icon(
//                   _isPlaying ? widget.pauseIcon : widget.playIcon,
//                   size: widget.iconSize,
//                 ),
//                 onPressed: _togglePlayPause,
//               ),
//               // Current position
//               Text(_formatDuration(_position)),
//               // Seek slider (optional)
//               if (widget.showSeekSlider)
//                 Expanded(
//                   child: Slider(
//                     value: _position.inSeconds
//                         .toDouble()
//                         .clamp(0, _duration.inSeconds.toDouble()),
//                     max: _duration.inSeconds.toDouble(),
//                     onChanged: (value) {
//                       final newPosition = Duration(seconds: value.toInt());
//                       _audioPlayer.seek(newPosition);
//                       _playerController.updateCurrentDuration(newPosition);
//                     },
//                   ),
//                 ),
//               // Total duration
//               Text(_formatDuration(_duration)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
