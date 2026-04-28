import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/hair_segmentation_service.dart';

final hairSegmentationServiceProvider = Provider<HairSegmentationService>((ref) {
  final service = HairSegmentationService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});