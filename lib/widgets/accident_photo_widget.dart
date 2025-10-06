import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AccidentPhotoWidget extends StatelessWidget {
  final List<String> photoUrls;
  final double? height;
  final double? width;
  final bool showTitle;

  const AccidentPhotoWidget({
    super.key,
    required this.photoUrls,
    this.height = 100,
    this.width = 100,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            'Photos',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () => _showFullScreenPhoto(context, photoUrls[index]),
                    child: Image.network(
                      photoUrls[index],
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: width,
                          height: height,
                          color: AppTheme.backgroundLight,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: width,
                          height: height,
                          color: AppTheme.backgroundLight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: AppTheme.textSecondary,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Failed to load',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullScreenPhoto(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccidentPhotoGrid extends StatelessWidget {
  final List<String> photoUrls;
  final int crossAxisCount;
  final double spacing;
  final bool showTitle;

  const AccidentPhotoGrid({
    super.key,
    required this.photoUrls,
    this.crossAxisCount = 2,
    this.spacing = 8.0,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            'Photos',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: photoUrls.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => _showFullScreenPhoto(context, photoUrls[index]),
                child: Image.network(
                  photoUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.backgroundLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.backgroundLight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: AppTheme.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Failed to load',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFullScreenPhoto(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
