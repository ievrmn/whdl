import 'package:flutter/material.dart';

class GiftAnimationWidget extends StatefulWidget {
  final String giftType; // مثل "أسد", "وردة", "كنغر", "سيارة"
  final VoidCallback? onAnimationComplete;

  const GiftAnimationWidget({
    Key? key,
    required this.giftType,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  _GiftAnimationWidgetState createState() => _GiftAnimationWidgetState();
}

class _GiftAnimationWidgetState extends State<GiftAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // عند انتهاء الأنيميشن، نفعل callback لو موجود
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          _controller.reverse().then((value) {
            if (widget.onAnimationComplete != null) {
              widget.onAnimationComplete!();
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGiftImage() {
    String assetName;
    switch (widget.giftType) {
      case 'أسد':
        assetName = 'assets/gifts/lion.png';
        break;
      case 'وردة':
        assetName = 'assets/gifts/rose.png';
        break;
      case 'كنغر':
        assetName = 'assets/gifts/kangaroo.png';
        break;
      case 'سيارة':
        assetName = 'assets/gifts/car.png';
        break;
      default:
        assetName = 'assets/gifts/default.png';
    }

    return Image.asset(
      assetName,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGiftImage(),
              SizedBox(height: 10),
              Text(
                'تم إرسال هدية ${widget.giftType}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}