import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';

/// 相机页面
class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({super.key, required this.camera});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    // 初始化相机控制器
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max, // 使用最高分辨率
      enableAudio: false, // 不需要音频
      imageFormatGroup: ImageFormatGroup.jpeg, // 使用JPEG格式
    );

    // 初始化控制器
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 释放控制器资源
    _controller.dispose();
    super.dispose();
  }

  /// 拍照
  Future<void> _takePicture() async {
    if (_isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      // 确保相机已初始化
      await _initializeControllerFuture;

      // 触发触觉反馈
      HapticFeedback.mediumImpact();

      // 拍照
      final XFile image = await _controller.takePicture();

      if (!mounted) return;

      // 返回图片文件
      Navigator.of(context).pop(image);
    } catch (e) {
      print('❌ 拍照失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('拍照失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // 相机预览
                Positioned.fill(
                  child: CameraPreview(_controller),
                ),

                // 顶部操作栏
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 返回按钮
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                child: const AppIcon(
                                  assetName: 'x-02',
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // 占位空间
                          const SizedBox(width: 48, height: 48),
                        ],
                      ),
                    ),
                  ),
                ),

                // 底部操作栏
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120 + MediaQuery.of(context).padding.bottom,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 拍照按钮
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isTakingPicture ? null : _takePicture,
                            borderRadius: BorderRadius.circular(36),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: _isTakingPicture
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
        },
      ),
    );
  }
}
