import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bookmates_app/VideoCall/screens/call_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class PreJoiningDialog extends StatefulWidget {
  const PreJoiningDialog({
    super.key,
    required this.token,
    required this.channelName,
  });

  final String token;
  final String channelName;

  @override
  State<PreJoiningDialog> createState() => _PreJoiningDialogState();
}

class _PreJoiningDialogState extends State<PreJoiningDialog> {
  bool _isMicEnabled = false;
  bool _isCameraEnabled = false;
  bool _isJoining = false;

  Future<void> _getMicPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final micPermission = await Permission.microphone.request();
      if (micPermission == PermissionStatus.granted) {
        setState(() => _isMicEnabled = true);
      }
    } else {
      setState(() => _isMicEnabled = !_isMicEnabled);
    }
  }

  Future<void> _getCameraPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission == PermissionStatus.granted) {
        setState(() => _isCameraEnabled = true);
      }
    } else {
      setState(() => _isCameraEnabled = !_isCameraEnabled);
    }
  }

  Future<void> _getPermissions() async {
    await _getMicPermissions();
    await _getCameraPermissions();
  }

  Future<void> _joinCall() async {
    setState(() => _isJoining = true);
    final appId = '3ea1be454c6a48caac7da827c295b65f';
    if (appId == null) {
      throw Exception('Please add your APP_ID to .env file');
    }
    setState(() => _isJoining = false);
    if (context.mounted) {
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallPage(
            appId: appId,
            token: widget.token,
            channelName: widget.channelName,
            isMicEnabled: _isMicEnabled,
            isVideoEnabled: _isCameraEnabled,
          ),
        ),
      );
    }
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    _getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 250, 241, 213),
      child: SizedBox(
        width: 350.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
            children: [
              Text(
                'Joining Call',
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold, // Bold text
                  fontFamily: 'Spartan', // Set font family
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'You are about to join a video call! Please set your mic and camera preferences.',
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontFamily: 'Spartan', // Set font family
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          if (_isMicEnabled) {
                            setState(() => _isMicEnabled = false);
                          } else {
                            _getMicPermissions();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 117, 161, 15),
                          radius: 32.0,
                          child: Icon(
                            _isMicEnabled
                                ? Icons.mic_rounded
                                : Icons.mic_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mic: ${_isMicEnabled ? 'On' : 'Off'}',
                        style: TextStyle(
                          fontFamily: 'Spartan', // Set font family
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          if (_isCameraEnabled) {
                            setState(() => _isCameraEnabled = false);
                          } else {
                            _getCameraPermissions();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 117, 161, 15),
                          radius: 32.0,
                          child: Icon(
                            _isCameraEnabled
                                ? Icons.videocam_rounded
                                : Icons.videocam_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Camera: ${_isCameraEnabled ? 'On' : 'Off'}',
                        style: TextStyle(
                          fontFamily: 'Spartan', // Set font family
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: _isJoining
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _joinCall,
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 117, 161, 15), // Button color
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Bold text
                            fontFamily: 'Spartan', // Set font family
                          ),
                        ),
                        child: const Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
