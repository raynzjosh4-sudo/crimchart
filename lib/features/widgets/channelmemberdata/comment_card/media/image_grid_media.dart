// import 'package:flutter/material.dart';

// class ImageGridMedia extends StatelessWidget {
//   final List<String> imageUrls;

//   const ImageGridMedia({super.key, required this.imageUrls});

//   @override
//   Widget build(BuildContext context) {
//     if (imageUrls.isEmpty) return const SizedBox.shrink();

//     final count = imageUrls.length;

//     if (count == 1) {
//       return _buildImage(imageUrls[0], height: 200, width: double.infinity);
//     } else if (count == 2) {
//       return SizedBox(
//         height: 200,
//         child: Row(
//           children: [
//             Expanded(child: _buildImage(imageUrls[0])),
//             const SizedBox(width: 4),
//             Expanded(child: _buildImage(imageUrls[1])),
//           ],
//         ),
//       );
//     } else if (count == 3) {
//       return SizedBox(
//         height: 200,
//         child: Row(
//           children: [
//             Expanded(flex: 2, child: _buildImage(imageUrls[0])),
//             const SizedBox(width: 4),
//             Expanded(
//               flex: 1,
//               child: Column(
//                 children: [
//                   Expanded(child: _buildImage(imageUrls[1])),
//                   const SizedBox(height: 4),
//                   Expanded(child: _buildImage(imageUrls[2])),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (count == 4) {
//       return SizedBox(
//         height: 240,
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(child: _buildImage(imageUrls[0])),
//                   const SizedBox(width: 4),
//                   Expanded(child: _buildImage(imageUrls[1])),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(child: _buildImage(imageUrls[2])),
//                   const SizedBox(width: 4),
//                   Expanded(child: _buildImage(imageUrls[3])),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // 5 or more images
//       return SizedBox(
//         height: 240,
//         child: Column(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Row(
//                 children: [
//                   Expanded(child: _buildImage(imageUrls[0])),
//                   const SizedBox(width: 4),
//                   Expanded(child: _buildImage(imageUrls[1])),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Expanded(
//               flex: 1,
//               child: Row(
//                 children: [
//                   Expanded(child: _buildImage(imageUrls[2])),
//                   const SizedBox(width: 4),
//                   Expanded(child: _buildImage(imageUrls[3])),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: _buildMoreImagesOverlay(imageUrls[4], count - 5),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Widget _buildImage(String url, {double? width, double? height}) {
//     return Image.network(
//       url,
//       width: width,
//       height: height,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) =>
//           Container(color: Colors.grey.shade800),
//     );
//   }

//   Widget _buildMoreImagesOverlay(String url, int remaining) {
//     if (remaining <= 0) {
//       return _buildImage(url);
//     }
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         _buildImage(url),
//         Container(
//           color: Colors.black54, // Dark overlay
//           alignment: Alignment.center,
//           child: Text(
//             '+$remaining',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
