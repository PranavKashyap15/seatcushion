import 'dart:async';

import 'package:cushion_1/normalization_provider.dart';
import 'package:cushion_1/communicationhandler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';
export 'heatmap_generate.dart';
class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({super.key});
  @override
  HeatmapWidgetState createState() => HeatmapWidgetState();
}
class HeatmapWidgetState extends State<HeatmapWidget> {
  TextEditingController textEditingController =
      TextEditingController(text: "BACK");
  final List<List<Offset>> cellVertices = [
    [
      const Offset(348, 105),
      const Offset(346, 106),
      const Offset(342, 110),
      const Offset(341, 112),
      const Offset(341, 116),
      const Offset(340, 117),
      const Offset(340, 144),
      const Offset(341, 145),
      const Offset(341, 148),
      const Offset(346, 153),
      const Offset(349, 153),
      const Offset(350, 154),
      const Offset(380, 154),
      const Offset(381, 153),
      const Offset(383, 153),
      const Offset(388, 148),
      const Offset(389, 146),
      const Offset(389, 113),
      const Offset(388, 112),
      const Offset(388, 110),
      const Offset(386, 109),
      const Offset(383, 106),
      const Offset(382, 106),
      const Offset(381, 105),
      const Offset(348, 105),
      const Offset(348, 105)
    ],
    [
      const Offset(291, 105),
      const Offset(289, 106),
      const Offset(284, 112),
      const Offset(284, 116),
      const Offset(283, 117),
      const Offset(283, 144),
      const Offset(284, 145),
      const Offset(284, 148),
      const Offset(289, 153),
      const Offset(292, 153),
      const Offset(293, 154),
      const Offset(323, 154),
      const Offset(324, 153),
      const Offset(326, 153),
      const Offset(331, 148),
      const Offset(332, 146),
      const Offset(332, 113),
      const Offset(331, 112),
      const Offset(331, 110),
      const Offset(329, 109),
      const Offset(326, 106),
      const Offset(325, 106),
      const Offset(324, 105),
      const Offset(291, 105),
      const Offset(291, 105)
    ],
    [
      const Offset(234, 105),
      const Offset(232, 106),
      const Offset(228, 110),
      const Offset(227, 112),
      const Offset(227, 116),
      const Offset(226, 117),
      const Offset(226, 144),
      const Offset(227, 145),
      const Offset(227, 148),
      const Offset(232, 153),
      const Offset(235, 153),
      const Offset(236, 154),
      const Offset(266, 154),
      const Offset(267, 153),
      const Offset(269, 153),
      const Offset(274, 148),
      const Offset(275, 146),
      const Offset(275, 113),
      const Offset(274, 112),
      const Offset(274, 110),
      const Offset(272, 109),
      const Offset(269, 106),
      const Offset(268, 106),
      const Offset(267, 105),
      const Offset(234, 105),
      const Offset(234, 105),
    ],
    [
      const Offset(177, 105),
      const Offset(175, 106),
      const Offset(171, 110),
      const Offset(170, 112),
      const Offset(170, 116),
      const Offset(169, 117),
      const Offset(169, 144),
      const Offset(170, 145),
      const Offset(170, 148),
      const Offset(175, 153),
      const Offset(178, 153),
      const Offset(179, 154),
      const Offset(209, 154),
      const Offset(210, 153),
      const Offset(212, 153),
      const Offset(217, 148),
      const Offset(218, 146),
      const Offset(218, 113),
      const Offset(217, 112),
      const Offset(217, 110),
      const Offset(215, 109),
      const Offset(212, 106),
      const Offset(211, 106),
      const Offset(210, 105),
      const Offset(177, 105),
      const Offset(177, 105),
    ],
    [
      const Offset(120, 105),
      const Offset(118, 106),
      const Offset(114, 110),
      const Offset(113, 112),
      const Offset(113, 116),
      const Offset(112, 117),
      const Offset(112, 144),
      const Offset(113, 145),
      const Offset(113, 148),
      const Offset(118, 153),
      const Offset(121, 153),
      const Offset(122, 154),
      const Offset(152, 154),
      const Offset(153, 153),
      const Offset(155, 153),
      const Offset(160, 148),
      const Offset(160, 147),
      const Offset(161, 146),
      const Offset(161, 113),
      const Offset(160, 112),
      const Offset(160, 111),
      const Offset(155, 106),
      const Offset(154, 106),
      const Offset(153, 105),
      const Offset(120, 105),
      const Offset(120, 105)
    ],
    [
      const Offset(348, 162),
      const Offset(346, 163),
      const Offset(342, 167),
      const Offset(341, 169),
      const Offset(341, 173),
      const Offset(340, 174),
      const Offset(340, 201),
      const Offset(341, 202),
      const Offset(341, 205),
      const Offset(346, 210),
      const Offset(349, 210),
      const Offset(350, 211),
      const Offset(380, 211),
      const Offset(381, 210),
      const Offset(383, 210),
      const Offset(388, 205),
      const Offset(388, 204),
      const Offset(389, 203),
      const Offset(389, 170),
      const Offset(388, 169),
      const Offset(388, 168),
      const Offset(383, 163),
      const Offset(382, 163),
      const Offset(381, 162),
      const Offset(348, 162),
      const Offset(348, 162)
    ],
    [
      const Offset(291, 162),
      const Offset(289, 163),
      const Offset(285, 167),
      const Offset(284, 169),
      const Offset(284, 173),
      const Offset(283, 174),
      const Offset(283, 201),
      const Offset(284, 202),
      const Offset(284, 205),
      const Offset(289, 210),
      const Offset(292, 210),
      const Offset(293, 211),
      const Offset(323, 211),
      const Offset(324, 210),
      const Offset(326, 210),
      const Offset(331, 205),
      const Offset(331, 204),
      const Offset(332, 203),
      const Offset(332, 170),
      const Offset(331, 169),
      const Offset(331, 168),
      const Offset(326, 163),
      const Offset(325, 163),
      const Offset(324, 162),
      const Offset(291, 162),
      const Offset(291, 162),
    ],
    [
      const Offset(234, 162),
      const Offset(232, 163),
      const Offset(228, 167),
      const Offset(227, 169),
      const Offset(227, 173),
      const Offset(226, 174),
      const Offset(226, 201),
      const Offset(227, 202),
      const Offset(227, 205),
      const Offset(232, 210),
      const Offset(235, 210),
      const Offset(236, 211),
      const Offset(266, 211),
      const Offset(267, 210),
      const Offset(269, 210),
      const Offset(274, 205),
      const Offset(274, 204),
      const Offset(275, 203),
      const Offset(275, 170),
      const Offset(274, 169),
      const Offset(274, 168),
      const Offset(269, 163),
      const Offset(268, 163),
      const Offset(267, 162),
      const Offset(234, 162),
      const Offset(234, 162),
    ],
    [
      const Offset(177, 162),
      const Offset(175, 163),
      const Offset(171, 167),
      const Offset(170, 169),
      const Offset(170, 173),
      const Offset(169, 174),
      const Offset(169, 201),
      const Offset(170, 202),
      const Offset(170, 205),
      const Offset(175, 210),
      const Offset(178, 210),
      const Offset(179, 211),
      const Offset(209, 211),
      const Offset(210, 210),
      const Offset(212, 210),
      const Offset(217, 205),
      const Offset(217, 204),
      const Offset(218, 203),
      const Offset(218, 170),
      const Offset(217, 169),
      const Offset(217, 168),
      const Offset(212, 163),
      const Offset(211, 163),
      const Offset(210, 162),
      const Offset(177, 162),
      const Offset(177, 162)
    ],
    [
      const Offset(120, 162),
      const Offset(118, 163),
      const Offset(114, 167),
      const Offset(113, 169),
      const Offset(113, 173),
      const Offset(112, 174),
      const Offset(112, 201),
      const Offset(113, 202),
      const Offset(113, 205),
      const Offset(118, 210),
      const Offset(121, 210),
      const Offset(122, 211),
      const Offset(152, 211),
      const Offset(153, 210),
      const Offset(155, 210),
      const Offset(160, 205),
      const Offset(160, 204),
      const Offset(161, 203),
      const Offset(161, 170),
      const Offset(160, 169),
      const Offset(160, 168),
      const Offset(155, 163),
      const Offset(154, 163),
      const Offset(153, 162),
      const Offset(120, 162),
      const Offset(120, 162)
    ],
    [
      const Offset(348, 219),
      const Offset(346, 220),
      const Offset(342, 224),
      const Offset(341, 226),
      const Offset(341, 230),
      const Offset(340, 231),
      const Offset(340, 258),
      const Offset(341, 259),
      const Offset(341, 262),
      const Offset(346, 267),
      const Offset(349, 267),
      const Offset(350, 268),
      const Offset(380, 268),
      const Offset(381, 267),
      const Offset(383, 267),
      const Offset(388, 262),
      const Offset(388, 261),
      const Offset(389, 260),
      const Offset(389, 227),
      const Offset(388, 226),
      const Offset(388, 225),
      const Offset(383, 220),
      const Offset(382, 220),
      const Offset(381, 219),
      const Offset(348, 219),
      const Offset(348, 219)
    ],
    [
      const Offset(291, 219),
      const Offset(289, 220),
      const Offset(285, 224),
      const Offset(284, 226),
      const Offset(284, 230),
      const Offset(283, 231),
      const Offset(283, 258),
      const Offset(284, 259),
      const Offset(284, 262),
      const Offset(289, 267),
      const Offset(292, 267),
      const Offset(293, 268),
      const Offset(323, 268),
      const Offset(324, 267),
      const Offset(326, 267),
      const Offset(331, 262),
      const Offset(331, 261),
      const Offset(332, 260),
      const Offset(332, 227),
      const Offset(331, 226),
      const Offset(331, 225),
      const Offset(326, 220),
      const Offset(325, 220),
      const Offset(324, 219),
      const Offset(291, 219),
      const Offset(291, 219)
    ],
    [
      const Offset(234, 219),
      const Offset(232, 220),
      const Offset(228, 224),
      const Offset(227, 226),
      const Offset(227, 230),
      const Offset(226, 231),
      const Offset(226, 258),
      const Offset(227, 259),
      const Offset(227, 262),
      const Offset(232, 267),
      const Offset(235, 267),
      const Offset(236, 268),
      const Offset(266, 268),
      const Offset(267, 267),
      const Offset(269, 267),
      const Offset(274, 262),
      const Offset(274, 261),
      const Offset(275, 260),
      const Offset(275, 227),
      const Offset(274, 226),
      const Offset(274, 225),
      const Offset(269, 220),
      const Offset(268, 220),
      const Offset(267, 219),
      const Offset(234, 219),
      const Offset(234, 219)
    ],
    [
      const Offset(177, 219),
      const Offset(175, 220),
      const Offset(171, 224),
      const Offset(170, 226),
      const Offset(170, 230),
      const Offset(169, 231),
      const Offset(169, 258),
      const Offset(170, 259),
      const Offset(170, 262),
      const Offset(175, 267),
      const Offset(178, 267),
      const Offset(179, 268),
      const Offset(209, 268),
      const Offset(210, 267),
      const Offset(212, 267),
      const Offset(217, 262),
      const Offset(217, 261),
      const Offset(218, 260),
      const Offset(218, 227),
      const Offset(217, 226),
      const Offset(217, 225),
      const Offset(212, 220),
      const Offset(211, 220),
      const Offset(210, 219),
      const Offset(177, 219),
      const Offset(177, 219)
    ],
    [
      const Offset(120, 219),
      const Offset(118, 220),
      const Offset(114, 224),
      const Offset(113, 226),
      const Offset(113, 230),
      const Offset(112, 231),
      const Offset(112, 258),
      const Offset(113, 259),
      const Offset(113, 262),
      const Offset(118, 267),
      const Offset(121, 267),
      const Offset(122, 268),
      const Offset(152, 268),
      const Offset(153, 267),
      const Offset(155, 267),
      const Offset(160, 262),
      const Offset(160, 261),
      const Offset(161, 260),
      const Offset(161, 227),
      const Offset(160, 226),
      const Offset(160, 225),
      const Offset(155, 220),
      const Offset(154, 220),
      const Offset(153, 219),
      const Offset(120, 219),
      const Offset(120, 219)
    ],
    [
      const Offset(348, 276),
      const Offset(346, 277),
      const Offset(342, 281),
      const Offset(341, 283),
      const Offset(341, 287),
      const Offset(340, 288),
      const Offset(340, 315),
      const Offset(341, 316),
      const Offset(341, 319),
      const Offset(346, 324),
      const Offset(349, 324),
      const Offset(350, 325),
      const Offset(380, 325),
      const Offset(381, 324),
      const Offset(383, 324),
      const Offset(388, 319),
      const Offset(388, 318),
      const Offset(389, 317),
      const Offset(389, 284),
      const Offset(388, 283),
      const Offset(388, 282),
      const Offset(383, 277),
      const Offset(382, 277),
      const Offset(381, 276),
      const Offset(348, 276),
      const Offset(348, 276)
    ],
    [
      const Offset(291, 276),
      const Offset(289, 277),
      const Offset(285, 281),
      const Offset(284, 283),
      const Offset(284, 287),
      const Offset(283, 288),
      const Offset(283, 315),
      const Offset(284, 316),
      const Offset(284, 319),
      const Offset(289, 324),
      const Offset(292, 324),
      const Offset(293, 325),
      const Offset(323, 325),
      const Offset(324, 324),
      const Offset(326, 324),
      const Offset(331, 319),
      const Offset(331, 318),
      const Offset(332, 317),
      const Offset(332, 284),
      const Offset(331, 283),
      const Offset(331, 282),
      const Offset(326, 277),
      const Offset(325, 277),
      const Offset(324, 276),
      const Offset(291, 276),
      const Offset(291, 276)
    ],
    [
      const Offset(234, 276),
      const Offset(232, 277),
      const Offset(228, 281),
      const Offset(227, 283),
      const Offset(227, 287),
      const Offset(226, 288),
      const Offset(226, 315),
      const Offset(227, 316),
      const Offset(227, 319),
      const Offset(232, 324),
      const Offset(235, 324),
      const Offset(236, 325),
      const Offset(266, 325),
      const Offset(267, 324),
      const Offset(269, 324),
      const Offset(274, 319),
      const Offset(274, 318),
      const Offset(275, 317),
      const Offset(275, 284),
      const Offset(274, 283),
      const Offset(274, 282),
      const Offset(269, 277),
      const Offset(268, 277),
      const Offset(267, 276),
      const Offset(234, 276),
      const Offset(234, 276)
    ],
    [
      const Offset(177, 276),
      const Offset(175, 277),
      const Offset(171, 281),
      const Offset(170, 283),
      const Offset(170, 287),
      const Offset(169, 288),
      const Offset(169, 315),
      const Offset(170, 316),
      const Offset(170, 319),
      const Offset(175, 324),
      const Offset(178, 324),
      const Offset(179, 325),
      const Offset(209, 325),
      const Offset(210, 324),
      const Offset(212, 324),
      const Offset(217, 319),
      const Offset(217, 318),
      const Offset(218, 317),
      const Offset(218, 284),
      const Offset(217, 283),
      const Offset(217, 282),
      const Offset(212, 277),
      const Offset(211, 277),
      const Offset(210, 276),
      const Offset(177, 276),
      const Offset(177, 276)
    ],
    [
      const Offset(120, 276),
      const Offset(118, 277),
      const Offset(114, 281),
      const Offset(113, 283),
      const Offset(113, 287),
      const Offset(112, 288),
      const Offset(112, 315),
      const Offset(113, 316),
      const Offset(113, 319),
      const Offset(118, 324),
      const Offset(121, 324),
      const Offset(122, 325),
      const Offset(152, 325),
      const Offset(153, 324),
      const Offset(155, 324),
      const Offset(160, 319),
      const Offset(160, 318),
      const Offset(161, 317),
      const Offset(161, 284),
      const Offset(160, 283),
      const Offset(160, 282),
      const Offset(155, 277),
      const Offset(154, 277),
      const Offset(153, 276),
      const Offset(120, 276),
      const Offset(120, 276)
    ],
    [
      const Offset(348, 333),
      const Offset(346, 334),
      const Offset(342, 338),
      const Offset(341, 340),
      const Offset(341, 344),
      const Offset(340, 345),
      const Offset(340, 372),
      const Offset(341, 373),
      const Offset(341, 376),
      const Offset(346, 381),
      const Offset(349, 381),
      const Offset(350, 382),
      const Offset(380, 382),
      const Offset(381, 381),
      const Offset(383, 381),
      const Offset(388, 376),
      const Offset(388, 375),
      const Offset(389, 374),
      const Offset(389, 341),
      const Offset(388, 340),
      const Offset(388, 339),
      const Offset(383, 334),
      const Offset(382, 334),
      const Offset(381, 333),
      const Offset(348, 333),
      const Offset(348, 333)
    ],
    [
      const Offset(291, 333),
      const Offset(289, 334),
      const Offset(285, 338),
      const Offset(284, 340),
      const Offset(284, 344),
      const Offset(283, 345),
      const Offset(283, 372),
      const Offset(284, 373),
      const Offset(284, 376),
      const Offset(289, 381),
      const Offset(292, 381),
      const Offset(293, 382),
      const Offset(323, 382),
      const Offset(324, 381),
      const Offset(326, 381),
      const Offset(331, 376),
      const Offset(331, 375),
      const Offset(332, 374),
      const Offset(332, 341),
      const Offset(331, 340),
      const Offset(331, 339),
      const Offset(326, 334),
      const Offset(325, 334),
      const Offset(324, 333),
      const Offset(291, 333),
      const Offset(291, 333)
    ],
    [
      const Offset(234, 333),
      const Offset(232, 334),
      const Offset(228, 338),
      const Offset(227, 340),
      const Offset(227, 344),
      const Offset(226, 345),
      const Offset(226, 372),
      const Offset(227, 373),
      const Offset(227, 376),
      const Offset(232, 381),
      const Offset(235, 381),
      const Offset(236, 382),
      const Offset(266, 382),
      const Offset(267, 381),
      const Offset(269, 381),
      const Offset(274, 376),
      const Offset(274, 375),
      const Offset(275, 374),
      const Offset(275, 341),
      const Offset(274, 340),
      const Offset(274, 339),
      const Offset(269, 334),
      const Offset(268, 334),
      const Offset(267, 333),
      const Offset(234, 333),
      const Offset(234, 333)
    ],
    [
      const Offset(177, 333),
      const Offset(175, 334),
      const Offset(171, 338),
      const Offset(170, 340),
      const Offset(170, 344),
      const Offset(169, 345),
      const Offset(169, 372),
      const Offset(170, 373),
      const Offset(170, 376),
      const Offset(175, 381),
      const Offset(178, 381),
      const Offset(179, 382),
      const Offset(209, 382),
      const Offset(210, 381),
      const Offset(212, 381),
      const Offset(217, 376),
      const Offset(217, 375),
      const Offset(218, 374),
      const Offset(218, 341),
      const Offset(217, 340),
      const Offset(217, 339),
      const Offset(212, 334),
      const Offset(211, 334),
      const Offset(210, 333),
      const Offset(177, 333),
      const Offset(177, 333)
    ],
    [
      const Offset(120, 333),
      const Offset(118, 334),
      const Offset(114, 338),
      const Offset(113, 340),
      const Offset(113, 344),
      const Offset(112, 345),
      const Offset(112, 372),
      const Offset(113, 373),
      const Offset(113, 376),
      const Offset(118, 381),
      const Offset(121, 381),
      const Offset(122, 382),
      const Offset(152, 382),
      const Offset(153, 381),
      const Offset(155, 381),
      const Offset(160, 376),
      const Offset(160, 375),
      const Offset(161, 374),
      const Offset(161, 341),
      const Offset(160, 340),
      const Offset(160, 339),
      const Offset(155, 334),
      const Offset(154, 334),
      const Offset(153, 333),
      const Offset(120, 333),
      const Offset(120, 333)
    ],
    [
      const Offset(406, 110),
      const Offset(405, 111),
      const Offset(403, 111),
      const Offset(398, 116),
      const Offset(398, 119),
      const Offset(397, 120),
      const Offset(397, 367),
      const Offset(398, 368),
      const Offset(398, 370),
      const Offset(399, 371),
      const Offset(399, 372),
      const Offset(402, 375),
      const Offset(403, 375),
      const Offset(404, 376),
      const Offset(494, 376),
      const Offset(498, 372),
      const Offset(500, 370),
      const Offset(500, 117),
      const Offset(499, 116),
      const Offset(499, 115),
      const Offset(497, 113),
      const Offset(495, 111),
      const Offset(493, 111),
      const Offset(492, 110),
      const Offset(406, 110),
      const Offset(406, 110)
    ],
    [
      const Offset(517, 110),
      const Offset(516, 111),
      const Offset(515, 111),
      const Offset(510, 116),
      const Offset(510, 117),
      const Offset(509, 118),
      const Offset(509, 369),
      const Offset(510, 370),
      const Offset(510, 371),
      const Offset(515, 376),
      const Offset(606, 376),
      const Offset(608, 374),
      const Offset(610, 372),
      const Offset(611, 371),
      const Offset(611, 369),
      const Offset(612, 368),
      const Offset(612, 118),
      const Offset(611, 117),
      const Offset(611, 116),
      const Offset(609, 114),
      const Offset(607, 112),
      const Offset(606, 111),
      const Offset(605, 111),
      const Offset(604, 110),
      const Offset(517, 110),
      const Offset(517, 110)
    ],
    [
      const Offset(629, 110),
      const Offset(628, 111),
      const Offset(626, 111),
      const Offset(621, 116),
      const Offset(621, 118),
      const Offset(620, 119),
      const Offset(620, 368),
      const Offset(622, 371),
      const Offset(622, 372),
      const Offset(625, 375),
      const Offset(626, 375),
      const Offset(627, 376),
      const Offset(717, 376),
      const Offset(722, 371),
      const Offset(722, 370),
      const Offset(723, 369),
      const Offset(723, 117),
      const Offset(722, 116),
      const Offset(722, 115),
      const Offset(720, 113),
      const Offset(719, 113),
      const Offset(717, 111),
      const Offset(716, 111),
      const Offset(715, 110),
      const Offset(629, 110),
      const Offset(629, 110)
    ],
    [
      const Offset(410, 21),
      const Offset(409, 22),
      const Offset(408, 22),
      const Offset(403, 27),
      const Offset(403, 90),
      const Offset(404, 91),
      const Offset(404, 92),
      const Offset(407, 95),
      const Offset(408, 95),
      const Offset(409, 96),
      const Offset(410, 96),
      const Offset(411, 97),
      const Offset(714, 97),
      const Offset(715, 96),
      const Offset(717, 96),
      const Offset(721, 92),
      const Offset(723, 90),
      const Offset(723, 28),
      const Offset(722, 27),
      const Offset(722, 26),
      const Offset(720, 24),
      const Offset(718, 22),
      const Offset(717, 22),
      const Offset(716, 21),
      const Offset(410, 21),
      const Offset(410, 21)
    ],
    [
      const Offset(51, 21),
      const Offset(45, 24),
      const Offset(43, 24),
      const Offset(40, 26),
      const Offset(34, 32),
      const Offset(29, 41),
      const Offset(28, 45),
      const Offset(28, 170),
      const Offset(30, 174),
      const Offset(35, 178),
      const Offset(97, 178),
      const Offset(99, 177),
      const Offset(103, 173),
      const Offset(104, 170),
      const Offset(104, 98),
      const Offset(105, 97),
      const Offset(367, 97),
      const Offset(371, 95),
      const Offset(375, 91),
      const Offset(376, 89),
      const Offset(376, 28),
      const Offset(375, 26),
      const Offset(371, 22),
      const Offset(369, 21),
      const Offset(51, 21),
      const Offset(51, 21)
    ],
    [
      const Offset(35, 190),
      const Offset(33, 192),
      const Offset(31, 193),
      const Offset(31, 194),
      const Offset(29, 196),
      const Offset(28, 198),
      const Offset(28, 368),
      const Offset(31, 373),
      const Offset(32, 373),
      const Offset(34, 375),
      const Offset(36, 376),
      const Offset(96, 376),
      const Offset(97, 375),
      const Offset(99, 375),
      const Offset(100, 373),
      const Offset(103, 370),
      const Offset(104, 368),
      const Offset(104, 198),
      const Offset(103, 196),
      const Offset(101, 194),
      const Offset(101, 193),
      const Offset(99, 191),
      const Offset(98, 191),
      const Offset(97, 190),
      const Offset(35, 190),
      const Offset(35, 190)
    ],
    [
      const Offset(348, 390),
      const Offset(346, 391),
      const Offset(342, 395),
      const Offset(341, 397),
      const Offset(341, 401),
      const Offset(340, 402),
      const Offset(340, 429),
      const Offset(341, 430),
      const Offset(341, 433),
      const Offset(346, 438),
      const Offset(349, 438),
      const Offset(350, 439),
      const Offset(380, 439),
      const Offset(381, 438),
      const Offset(383, 438),
      const Offset(388, 433),
      const Offset(389, 431),
      const Offset(389, 398),
      const Offset(388, 397),
      const Offset(388, 395),
      const Offset(386, 394),
      const Offset(383, 391),
      const Offset(382, 391),
      const Offset(381, 390),
      const Offset(348, 390),
      const Offset(348, 390)
    ],
    [
      const Offset(291, 390),
      const Offset(289, 391),
      const Offset(285, 395),
      const Offset(284, 397),
      const Offset(284, 401),
      const Offset(283, 402),
      const Offset(283, 429),
      const Offset(284, 430),
      const Offset(284, 433),
      const Offset(289, 438),
      const Offset(292, 438),
      const Offset(293, 439),
      const Offset(323, 439),
      const Offset(324, 438),
      const Offset(326, 438),
      const Offset(331, 433),
      const Offset(332, 431),
      const Offset(332, 398),
      const Offset(331, 397),
      const Offset(331, 395),
      const Offset(329, 394),
      const Offset(326, 391),
      const Offset(325, 391),
      const Offset(324, 390),
      const Offset(291, 390),
      const Offset(291, 390)
    ],
    [
      const Offset(234, 390),
      const Offset(232, 391),
      const Offset(228, 395),
      const Offset(227, 397),
      const Offset(227, 401),
      const Offset(226, 402),
      const Offset(226, 429),
      const Offset(227, 430),
      const Offset(227, 433),
      const Offset(232, 438),
      const Offset(235, 438),
      const Offset(236, 439),
      const Offset(266, 439),
      const Offset(267, 438),
      const Offset(269, 438),
      const Offset(274, 433),
      const Offset(275, 431),
      const Offset(275, 398),
      const Offset(274, 397),
      const Offset(274, 395),
      const Offset(272, 394),
      const Offset(269, 391),
      const Offset(268, 391),
      const Offset(267, 390),
      const Offset(234, 390),
      const Offset(234, 390)
    ],
    [
      const Offset(177, 390),
      const Offset(175, 391),
      const Offset(171, 395),
      const Offset(170, 397),
      const Offset(170, 401),
      const Offset(169, 402),
      const Offset(169, 429),
      const Offset(170, 430),
      const Offset(170, 433),
      const Offset(175, 438),
      const Offset(178, 438),
      const Offset(179, 439),
      const Offset(209, 439),
      const Offset(210, 438),
      const Offset(212, 438),
      const Offset(217, 433),
      const Offset(218, 431),
      const Offset(218, 398),
      const Offset(217, 397),
      const Offset(217, 395),
      const Offset(215, 394),
      const Offset(212, 391),
      const Offset(211, 391),
      const Offset(210, 390),
      const Offset(177, 390),
      const Offset(177, 390)
    ],
    [
      const Offset(120, 390),
      const Offset(118, 391),
      const Offset(114, 395),
      const Offset(113, 397),
      const Offset(113, 401),
      const Offset(112, 402),
      const Offset(112, 429),
      const Offset(113, 430),
      const Offset(113, 433),
      const Offset(118, 438),
      const Offset(121, 438),
      const Offset(122, 439),
      const Offset(152, 439),
      const Offset(153, 438),
      const Offset(155, 438),
      const Offset(160, 433),
      const Offset(160, 432),
      const Offset(161, 431),
      const Offset(161, 398),
      const Offset(160, 397),
      const Offset(160, 396),
      const Offset(155, 391),
      const Offset(154, 391),
      const Offset(153, 390),
      const Offset(120, 390),
      const Offset(120, 390)
    ],
    [
      const Offset(348, 447),
      const Offset(346, 448),
      const Offset(342, 452),
      const Offset(341, 454),
      const Offset(341, 458),
      const Offset(340, 459),
      const Offset(340, 486),
      const Offset(341, 487),
      const Offset(341, 490),
      const Offset(346, 495),
      const Offset(349, 495),
      const Offset(350, 496),
      const Offset(380, 496),
      const Offset(381, 495),
      const Offset(383, 495),
      const Offset(388, 490),
      const Offset(389, 488),
      const Offset(389, 455),
      const Offset(388, 454),
      const Offset(388, 452),
      const Offset(386, 451),
      const Offset(383, 448),
      const Offset(382, 448),
      const Offset(381, 447),
      const Offset(348, 447),
      const Offset(348, 447)
    ],
    [
      const Offset(291, 447),
      const Offset(289, 448),
      const Offset(285, 452),
      const Offset(284, 454),
      const Offset(284, 458),
      const Offset(283, 459),
      const Offset(283, 486),
      const Offset(284, 487),
      const Offset(284, 490),
      const Offset(289, 495),
      const Offset(292, 495),
      const Offset(293, 496),
      const Offset(323, 496),
      const Offset(324, 495),
      const Offset(326, 495),
      const Offset(331, 490),
      const Offset(332, 488),
      const Offset(332, 455),
      const Offset(331, 454),
      const Offset(331, 452),
      const Offset(329, 451),
      const Offset(326, 448),
      const Offset(325, 448),
      const Offset(324, 447),
      const Offset(291, 447),
      const Offset(291, 447)
    ],
    [
      const Offset(234, 447),
      const Offset(232, 448),
      const Offset(228, 452),
      const Offset(227, 454),
      const Offset(227, 458),
      const Offset(226, 459),
      const Offset(226, 486),
      const Offset(227, 487),
      const Offset(227, 490),
      const Offset(232, 495),
      const Offset(235, 495),
      const Offset(236, 496),
      const Offset(266, 496),
      const Offset(267, 495),
      const Offset(269, 495),
      const Offset(274, 490),
      const Offset(275, 488),
      const Offset(275, 455),
      const Offset(274, 454),
      const Offset(274, 452),
      const Offset(272, 451),
      const Offset(269, 448),
      const Offset(268, 448),
      const Offset(267, 447),
      const Offset(234, 447),
      const Offset(234, 447)
    ],
    [
      const Offset(177, 447),
      const Offset(175, 448),
      const Offset(171, 452),
      const Offset(170, 454),
      const Offset(170, 458),
      const Offset(169, 459),
      const Offset(169, 486),
      const Offset(170, 487),
      const Offset(170, 490),
      const Offset(175, 495),
      const Offset(178, 495),
      const Offset(179, 496),
      const Offset(209, 496),
      const Offset(210, 495),
      const Offset(212, 495),
      const Offset(217, 490),
      const Offset(218, 488),
      const Offset(218, 455),
      const Offset(217, 454),
      const Offset(217, 452),
      const Offset(215, 451),
      const Offset(212, 448),
      const Offset(211, 448),
      const Offset(210, 447),
      const Offset(177, 447),
      const Offset(177, 447)
    ],
    [
      const Offset(120, 447),
      const Offset(118, 448),
      const Offset(114, 452),
      const Offset(113, 454),
      const Offset(113, 458),
      const Offset(112, 459),
      const Offset(112, 486),
      const Offset(113, 487),
      const Offset(113, 490),
      const Offset(118, 495),
      const Offset(121, 495),
      const Offset(122, 496),
      const Offset(152, 496),
      const Offset(153, 495),
      const Offset(155, 495),
      const Offset(160, 490),
      const Offset(160, 489),
      const Offset(161, 488),
      const Offset(161, 455),
      const Offset(160, 454),
      const Offset(160, 453),
      const Offset(155, 448),
      const Offset(154, 448),
      const Offset(153, 447),
      const Offset(120, 447),
      const Offset(120, 447)
    ],
    [
      const Offset(348, 504),
      const Offset(346, 505),
      const Offset(342, 509),
      const Offset(341, 511),
      const Offset(341, 515),
      const Offset(340, 516),
      const Offset(340, 543),
      const Offset(341, 544),
      const Offset(341, 547),
      const Offset(346, 552),
      const Offset(348, 552),
      const Offset(349, 553),
      const Offset(380, 553),
      const Offset(381, 552),
      const Offset(383, 552),
      const Offset(388, 547),
      const Offset(389, 545),
      const Offset(389, 512),
      const Offset(388, 511),
      const Offset(388, 509),
      const Offset(386, 508),
      const Offset(383, 505),
      const Offset(382, 505),
      const Offset(381, 504),
      const Offset(348, 504),
      const Offset(348, 504)
    ],
    [
      const Offset(291, 504),
      const Offset(289, 505),
      const Offset(285, 509),
      const Offset(284, 511),
      const Offset(284, 515),
      const Offset(283, 516),
      const Offset(283, 543),
      const Offset(284, 544),
      const Offset(284, 547),
      const Offset(289, 552),
      const Offset(291, 552),
      const Offset(292, 553),
      const Offset(323, 553),
      const Offset(324, 552),
      const Offset(326, 552),
      const Offset(331, 547),
      const Offset(332, 545),
      const Offset(332, 512),
      const Offset(331, 511),
      const Offset(331, 509),
      const Offset(329, 508),
      const Offset(326, 505),
      const Offset(325, 505),
      const Offset(324, 504),
      const Offset(291, 504),
      const Offset(291, 504)
    ],
    [
      const Offset(234, 504),
      const Offset(232, 505),
      const Offset(228, 509),
      const Offset(227, 511),
      const Offset(227, 515),
      const Offset(226, 516),
      const Offset(226, 543),
      const Offset(227, 544),
      const Offset(227, 547),
      const Offset(232, 552),
      const Offset(234, 552),
      const Offset(235, 553),
      const Offset(266, 553),
      const Offset(267, 552),
      const Offset(269, 552),
      const Offset(274, 547),
      const Offset(275, 545),
      const Offset(275, 512),
      const Offset(274, 511),
      const Offset(274, 509),
      const Offset(272, 508),
      const Offset(269, 505),
      const Offset(268, 505),
      const Offset(267, 504),
      const Offset(234, 504),
      const Offset(234, 504)
    ],
    [
      const Offset(177, 504),
      const Offset(175, 505),
      const Offset(171, 509),
      const Offset(170, 511),
      const Offset(170, 515),
      const Offset(169, 516),
      const Offset(169, 543),
      const Offset(170, 544),
      const Offset(170, 547),
      const Offset(175, 552),
      const Offset(177, 552),
      const Offset(178, 553),
      const Offset(209, 553),
      const Offset(210, 552),
      const Offset(212, 552),
      const Offset(217, 547),
      const Offset(218, 545),
      const Offset(218, 512),
      const Offset(217, 511),
      const Offset(217, 509),
      const Offset(215, 508),
      const Offset(212, 505),
      const Offset(211, 505),
      const Offset(210, 504),
      const Offset(177, 504),
      const Offset(177, 504)
    ],
    [
      const Offset(120, 504),
      const Offset(118, 505),
      const Offset(114, 509),
      const Offset(113, 511),
      const Offset(113, 515),
      const Offset(112, 516),
      const Offset(112, 543),
      const Offset(113, 544),
      const Offset(113, 547),
      const Offset(118, 552),
      const Offset(120, 552),
      const Offset(121, 553),
      const Offset(152, 553),
      const Offset(153, 552),
      const Offset(155, 552),
      const Offset(160, 547),
      const Offset(160, 546),
      const Offset(161, 545),
      const Offset(161, 512),
      const Offset(160, 511),
      const Offset(160, 510),
      const Offset(155, 505),
      const Offset(154, 505),
      const Offset(153, 504),
      const Offset(120, 504),
      const Offset(120, 504)
    ],
    [
      const Offset(348, 561),
      const Offset(346, 562),
      const Offset(342, 566),
      const Offset(341, 568),
      const Offset(341, 572),
      const Offset(340, 573),
      const Offset(340, 600),
      const Offset(341, 601),
      const Offset(341, 604),
      const Offset(346, 609),
      const Offset(348, 609),
      const Offset(349, 610),
      const Offset(380, 610),
      const Offset(381, 609),
      const Offset(383, 609),
      const Offset(388, 604),
      const Offset(388, 603),
      const Offset(389, 602),
      const Offset(389, 569),
      const Offset(388, 568),
      const Offset(388, 567),
      const Offset(383, 562),
      const Offset(382, 562),
      const Offset(381, 561),
      const Offset(348, 561),
      const Offset(348, 561)
    ],
    [
      const Offset(291, 561),
      const Offset(289, 562),
      const Offset(285, 566),
      const Offset(284, 568),
      const Offset(284, 572),
      const Offset(283, 573),
      const Offset(283, 600),
      const Offset(284, 601),
      const Offset(284, 604),
      const Offset(289, 609),
      const Offset(291, 609),
      const Offset(292, 610),
      const Offset(323, 610),
      const Offset(324, 609),
      const Offset(326, 609),
      const Offset(331, 604),
      const Offset(331, 603),
      const Offset(332, 602),
      const Offset(332, 569),
      const Offset(331, 568),
      const Offset(331, 567),
      const Offset(326, 562),
      const Offset(325, 562),
      const Offset(324, 561),
      const Offset(291, 561),
      const Offset(291, 561)
    ],
    [
      const Offset(234, 561),
      const Offset(232, 562),
      const Offset(228, 566),
      const Offset(227, 568),
      const Offset(227, 572),
      const Offset(226, 573),
      const Offset(226, 600),
      const Offset(227, 601),
      const Offset(227, 604),
      const Offset(232, 609),
      const Offset(234, 609),
      const Offset(235, 610),
      const Offset(266, 610),
      const Offset(267, 609),
      const Offset(269, 609),
      const Offset(274, 604),
      const Offset(274, 603),
      const Offset(275, 602),
      const Offset(275, 569),
      const Offset(274, 568),
      const Offset(274, 567),
      const Offset(269, 562),
      const Offset(268, 562),
      const Offset(267, 561),
      const Offset(234, 561),
      const Offset(234, 561)
    ],
    [
      const Offset(177, 561),
      const Offset(175, 562),
      const Offset(171, 566),
      const Offset(170, 568),
      const Offset(170, 572),
      const Offset(169, 573),
      const Offset(169, 600),
      const Offset(170, 601),
      const Offset(170, 604),
      const Offset(175, 609),
      const Offset(177, 609),
      const Offset(178, 610),
      const Offset(209, 610),
      const Offset(210, 609),
      const Offset(212, 609),
      const Offset(217, 604),
      const Offset(217, 603),
      const Offset(218, 602),
      const Offset(218, 569),
      const Offset(217, 568),
      const Offset(217, 567),
      const Offset(212, 562),
      const Offset(211, 562),
      const Offset(210, 561),
      const Offset(177, 561),
      const Offset(177, 561)
    ],
    [
      const Offset(120, 561),
      const Offset(118, 562),
      const Offset(114, 566),
      const Offset(113, 568),
      const Offset(113, 572),
      const Offset(112, 573),
      const Offset(112, 600),
      const Offset(113, 601),
      const Offset(113, 604),
      const Offset(118, 609),
      const Offset(120, 609),
      const Offset(121, 610),
      const Offset(152, 610),
      const Offset(153, 609),
      const Offset(155, 609),
      const Offset(160, 604),
      const Offset(160, 603),
      const Offset(161, 602),
      const Offset(161, 569),
      const Offset(160, 568),
      const Offset(160, 567),
      const Offset(155, 562),
      const Offset(154, 562),
      const Offset(153, 561),
      const Offset(120, 561),
      const Offset(120, 561)
    ],
    [
      const Offset(348, 618),
      const Offset(346, 619),
      const Offset(342, 623),
      const Offset(341, 625),
      const Offset(341, 629),
      const Offset(340, 630),
      const Offset(340, 657),
      const Offset(341, 658),
      const Offset(341, 661),
      const Offset(346, 666),
      const Offset(348, 666),
      const Offset(349, 667),
      const Offset(380, 667),
      const Offset(381, 666),
      const Offset(383, 666),
      const Offset(388, 661),
      const Offset(388, 660),
      const Offset(389, 659),
      const Offset(389, 626),
      const Offset(388, 625),
      const Offset(388, 624),
      const Offset(383, 619),
      const Offset(382, 619),
      const Offset(381, 618),
      const Offset(348, 618),
      const Offset(348, 618)
    ],
    [
      const Offset(291, 618),
      const Offset(289, 619),
      const Offset(285, 623),
      const Offset(284, 625),
      const Offset(284, 629),
      const Offset(283, 630),
      const Offset(283, 657),
      const Offset(284, 658),
      const Offset(284, 661),
      const Offset(289, 666),
      const Offset(291, 666),
      const Offset(292, 667),
      const Offset(323, 667),
      const Offset(324, 666),
      const Offset(326, 666),
      const Offset(331, 661),
      const Offset(331, 660),
      const Offset(332, 659),
      const Offset(332, 626),
      const Offset(331, 625),
      const Offset(331, 624),
      const Offset(326, 619),
      const Offset(325, 619),
      const Offset(324, 618),
      const Offset(291, 618),
      const Offset(291, 618)
    ],
    [
      const Offset(234, 618),
      const Offset(232, 619),
      const Offset(228, 623),
      const Offset(227, 625),
      const Offset(227, 629),
      const Offset(226, 630),
      const Offset(226, 657),
      const Offset(227, 658),
      const Offset(227, 661),
      const Offset(232, 666),
      const Offset(234, 666),
      const Offset(235, 667),
      const Offset(266, 667),
      const Offset(267, 666),
      const Offset(269, 666),
      const Offset(274, 661),
      const Offset(274, 660),
      const Offset(275, 659),
      const Offset(275, 626),
      const Offset(274, 625),
      const Offset(274, 624),
      const Offset(269, 619),
      const Offset(268, 619),
      const Offset(267, 618),
      const Offset(234, 618),
      const Offset(234, 618)
    ],
    [
      const Offset(177, 618),
      const Offset(175, 619),
      const Offset(171, 623),
      const Offset(170, 625),
      const Offset(170, 629),
      const Offset(169, 630),
      const Offset(169, 657),
      const Offset(170, 658),
      const Offset(170, 661),
      const Offset(175, 666),
      const Offset(177, 666),
      const Offset(178, 667),
      const Offset(209, 667),
      const Offset(210, 666),
      const Offset(212, 666),
      const Offset(217, 661),
      const Offset(217, 660),
      const Offset(218, 659),
      const Offset(218, 626),
      const Offset(217, 625),
      const Offset(217, 624),
      const Offset(212, 619),
      const Offset(211, 619),
      const Offset(210, 618),
      const Offset(177, 618),
      const Offset(177, 618)
    ],
    [
      const Offset(120, 618),
      const Offset(118, 619),
      const Offset(114, 623),
      const Offset(113, 625),
      const Offset(113, 629),
      const Offset(112, 630),
      const Offset(112, 657),
      const Offset(113, 658),
      const Offset(113, 661),
      const Offset(118, 666),
      const Offset(120, 666),
      const Offset(121, 667),
      const Offset(152, 667),
      const Offset(153, 666),
      const Offset(155, 666),
      const Offset(160, 661),
      const Offset(160, 660),
      const Offset(161, 659),
      const Offset(161, 626),
      const Offset(160, 625),
      const Offset(160, 624),
      const Offset(155, 619),
      const Offset(154, 619),
      const Offset(153, 618),
      const Offset(120, 618),
      const Offset(120, 618)
    ],
    [
      const Offset(406, 395),
      const Offset(405, 396),
      const Offset(403, 396),
      const Offset(398, 401),
      const Offset(398, 404),
      const Offset(397, 405),
      const Offset(397, 652),
      const Offset(398, 653),
      const Offset(399, 657),
      const Offset(402, 660),
      const Offset(406, 661),
      const Offset(408, 662),
      const Offset(409, 661),
      const Offset(494, 661),
      const Offset(500, 655),
      const Offset(500, 652),
      const Offset(501, 651),
      const Offset(501, 407),
      const Offset(500, 406),
      const Offset(500, 402),
      const Offset(499, 400),
      const Offset(496, 397),
      const Offset(493, 396),
      const Offset(492, 395),
      const Offset(406, 395),
      const Offset(406, 395)
    ],
    [
      const Offset(517, 395),
      const Offset(516, 396),
      const Offset(515, 396),
      const Offset(510, 401),
      const Offset(510, 402),
      const Offset(509, 403),
      const Offset(509, 654),
      const Offset(510, 655),
      const Offset(510, 656),
      const Offset(515, 661),
      const Offset(606, 661),
      const Offset(608, 659),
      const Offset(610, 657),
      const Offset(611, 656),
      const Offset(611, 654),
      const Offset(612, 653),
      const Offset(612, 403),
      const Offset(611, 402),
      const Offset(611, 401),
      const Offset(609, 399),
      const Offset(607, 397),
      const Offset(606, 396),
      const Offset(605, 396),
      const Offset(604, 395),
      const Offset(517, 395),
      const Offset(517, 395)
    ],
    [
      const Offset(629, 395),
      const Offset(628, 396),
      const Offset(626, 396),
      const Offset(621, 401),
      const Offset(621, 403),
      const Offset(620, 404),
      const Offset(620, 653),
      const Offset(622, 656),
      const Offset(622, 657),
      const Offset(625, 660),
      const Offset(627, 661),
      const Offset(629, 661),
      const Offset(631, 662),
      const Offset(632, 661),
      const Offset(717, 661),
      const Offset(722, 656),
      const Offset(723, 654),
      const Offset(723, 402),
      const Offset(722, 400),
      const Offset(720, 398),
      const Offset(719, 398),
      const Offset(717, 396),
      const Offset(716, 396),
      const Offset(715, 395),
      const Offset(629, 395),
      const Offset(629, 395)
    ],
    [
      const Offset(411, 675),
      const Offset(410, 676),
      const Offset(408, 676),
      const Offset(403, 681),
      const Offset(403, 684),
      const Offset(402, 686),
      const Offset(403, 687),
      const Offset(403, 745),
      const Offset(408, 750),
      const Offset(410, 750),
      const Offset(411, 751),
      const Offset(715, 751),
      const Offset(717, 750),
      const Offset(719, 748),
      const Offset(720, 748),
      const Offset(722, 746),
      const Offset(722, 745),
      const Offset(723, 744),
      const Offset(723, 682),
      const Offset(722, 681),
      const Offset(722, 680),
      const Offset(718, 676),
      const Offset(716, 676),
      const Offset(715, 675),
      const Offset(411, 675),
      const Offset(411, 675)
    ],
    [
      const Offset(37, 593),
      const Offset(34, 594),
      const Offset(29, 599),
      const Offset(28, 602),
      const Offset(28, 727),
      const Offset(30, 731),
      const Offset(30, 733),
      const Offset(34, 740),
      const Offset(39, 745),
      const Offset(46, 749),
      const Offset(51, 750),
      const Offset(52, 751),
      const Offset(368, 751),
      const Offset(373, 748),
      const Offset(376, 744),
      const Offset(376, 682),
      const Offset(373, 678),
      const Offset(368, 675),
      const Offset(105, 675),
      const Offset(104, 674),
      const Offset(104, 601),
      const Offset(103, 599),
      const Offset(98, 594),
      const Offset(96, 593),
      const Offset(37, 593),
      const Offset(37, 593)
    ],
    [
      const Offset(35, 396),
      const Offset(33, 398),
      const Offset(32, 398),
      const Offset(31, 399),
      const Offset(31, 400),
      const Offset(29, 402),
      const Offset(29, 403),
      const Offset(28, 404),
      const Offset(28, 574),
      const Offset(29, 575),
      const Offset(29, 576),
      const Offset(34, 581),
      const Offset(35, 581),
      const Offset(36, 582),
      const Offset(96, 582),
      const Offset(97, 581),
      const Offset(98, 581),
      const Offset(103, 576),
      const Offset(103, 575),
      const Offset(104, 574),
      const Offset(104, 404),
      const Offset(103, 403),
      const Offset(103, 401),
      const Offset(98, 396),
      const Offset(35, 396),
      const Offset(35, 396)
    ]
  ];

  final List<Offset> centers = [
    const Offset(129.471753794266, 364.597807757167),
    const Offset(129.471753794266, 307.597807757167),
    const Offset(129.471753794266, 250.597807757167),
    const Offset(129.471753794266, 193.597807757167),
    const Offset(129.488607594937, 136.578481012658),
    const Offset(186.488607594937, 364.578481012658),
    const Offset(186.488607594937, 307.578481012658),
    const Offset(186.488607594937, 250.578481012658),
    const Offset(186.488607594937, 193.578481012658),
    const Offset(186.488607594937, 136.578481012658),
    const Offset(243.488607594937, 364.578481012658),
    const Offset(243.488607594937, 307.578481012658),
    const Offset(243.488607594937, 250.578481012658),
    const Offset(243.488607594937, 193.578481012658),
    const Offset(243.488607594937, 136.578481012658),
    const Offset(300.488607594937, 364.578481012658),
    const Offset(300.488607594937, 307.578481012658),
    const Offset(300.488607594937, 250.578481012658),
    const Offset(300.488607594937, 193.578481012658),
    const Offset(300.488607594937, 136.578481012658),
    const Offset(357.488607594937, 364.578481012658),
    const Offset(357.488607594937, 307.578481012658),
    const Offset(357.488607594937, 250.578481012658),
    const Offset(357.488607594937, 193.578481012658),
    const Offset(357.488607594937, 136.578481012658),
    const Offset(243.047173221515, 448.524978311163),
    const Offset(243.070780464881, 560.498138307487),
    const Offset(243.052127390377, 671.515996095868),
    const Offset(58.9854572043710, 562.961733761222),
    const Offset(74.0090493601463, 177.023705057892),
    const Offset(282.980545836249, 66.0020293911827),
    const Offset(414.471753794266, 364.597807757167),
    const Offset(414.471753794266, 307.597807757167),
    const Offset(414.471753794266, 250.597807757167),
    const Offset(414.471753794266, 193.597807757167),
    const Offset(414.488607594937, 136.578481012658),
    const Offset(471.471753794266, 364.597807757167),
    const Offset(471.471753794266, 307.597807757167),
    const Offset(471.471753794266, 250.597807757167),
    const Offset(471.471753794266, 193.597807757167),
    const Offset(471.488607594937, 136.578481012658),
    const Offset(528.482090181205, 364.591234723978),
    const Offset(528.482090181205, 307.591234723978),
    const Offset(528.482090181205, 250.591234723978),
    const Offset(528.482090181205, 193.591234723978),
    const Offset(528.498945592577, 136.571910586251),
    const Offset(585.498945592577, 364.571910586251),
    const Offset(585.498945592577, 307.571910586251),
    const Offset(585.498945592577, 250.571910586251),
    const Offset(585.498945592577, 193.571910586251),
    const Offset(585.498945592577, 136.571910586251),
    const Offset(642.498945592577, 364.571910586251),
    const Offset(642.498945592577, 307.571910586251),
    const Offset(642.498945592577, 250.571910586251),
    const Offset(642.498945592577, 193.571910586251),
    const Offset(642.498945592577, 136.571910586251),
    const Offset(528.069867431028, 448.981010390541),
    const Offset(528.070780464881, 560.498138307487),
    const Offset(528.061810952467, 671.513030905476),
    const Offset(712.994801608253, 562.961296348942),
    const Offset(697.770171223503, 176.841002402603),
    const Offset(488.936314647631, 66.0096577787109)

    // Add all other centers here...
  ];
  final List<int> cellNumbers = [
    47,
    47,
    47,
    47,
    47,
    36,
    37,
    38,
    39,
    40,
    31,
    32,
    33,
    34,
    35,
    26,
    27,
    28,
    29,
    30,
    21,
    22,
    23,
    24,
    25,
    44,
    45,
    46,
    48,
    48,
    48,
    16,
    17,
    18,
    19,
    20,
    11,
    12,
    13,
    14,
    15,
    6,
    7,
    8,
    9,
    10,
    1,
    2,
    3,
    4,
    5,
    47,
    47,
    47,
    47,
    47,
    41,
    42,
    43,
    48,
    48,
    48
  ];
  // final Map<int, double> cellPressures = {
  
  // }; //right
  // final Map<int, double> cellPressures = {
 
  // }; //FORWARD

  // final Map<int, double> cellPressures = {
  
  // }; //left
  // final Map<int, double> cellPressures = {
  
  // }; //BACK
  // final Map<int, double> cellPressures = {
  // };

  // final Map<int, double> cellPressures = {};
  Map<int, double> cellPressures = {};
  StreamSubscription<Map<int, double>>? cellPressureSubscription;

  List<List<Offset>> scaledCellVertices = [];
  List<Offset> scaledCenters = [];
  Offset calculateCentroid(List<Offset> vertices) {
    double centroidX = 0.0;
    double centroidY = 0.0;
    double signedArea = 0.0;
    double x0 = 0.0; // Current vertex X
    double y0 = 0.0; // Current vertex Y
    double x1 = 0.0; // Next vertex X
    double y1 = 0.0; // Next vertex Y
    double a = 0.0; // Partial signed area
    // For all vertices except last
    int i = 0;
    for (i = 0; i < vertices.length - 1; ++i) {
      x0 = vertices[i].dx;
      y0 = vertices[i].dy;
      x1 = vertices[i + 1].dx;
      y1 = vertices[i + 1].dy;
      a = x0 * y1 - x1 * y0;
      signedArea += a;
      centroidX += (x0 + x1) * a;
      centroidY += (y0 + y1) * a;
    }
    // Do last vertex
    x0 = vertices[i].dx;
    y0 = vertices[i].dy;
    x1 = vertices[0].dx;
    y1 = vertices[0].dy;
    a = x0 * y1 - x1 * y0;
    signedArea += a;
    centroidX += (x0 + x1) * a;
    centroidY += (y0 + y1) * a;

    signedArea *= 0.5;
    centroidX /= (6.0 * signedArea);
    centroidY /= (6.0 * signedArea);

    return Offset(centroidX, centroidY);
  }

  @override
  void initState() {
    super.initState();
    final communicationHandler = CommunicationHandler.getInstance();
    cellPressureSubscription = communicationHandler.cellPressureUpdates.listen(
      (Map<int, double> pressures) {
        setState(() {
          cellPressures.clear();
          cellPressures.addAll(pressures);
        });
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => scaleToFit());
  }

  void scaleToFit() {
    // Obtain the screen size
    final screenSize = MediaQuery.of(context).size;
    // Call scaleHeatmapToFitScreen with the screen dimensions
    scaleHeatmapToFitScreen(
      screenSize.width,
      screenSize.height * 0.6, // Adjust the factor as needed for your layout
    );
  }

  void scaleHeatmapToFitScreen(double screenWidth, double screenHeight) {
    // Find the bounds of the heatmap
    double minX = cellVertices.expand((i) => i).map((e) => e.dx).reduce(min);
    double maxX = cellVertices.expand((i) => i).map((e) => e.dx).reduce(max);
    double minY = cellVertices.expand((i) => i).map((e) => e.dy).reduce(min);
    double maxY = cellVertices.expand((i) => i).map((e) => e.dy).reduce(max);

    // Calculate the size of the heatmap
    double heatmapWidth = maxX - minX;
    double heatmapHeight = maxY - minY;

    // Calculate the scale factors
    double scaleX = screenWidth / heatmapWidth;
    double scaleY = screenHeight / heatmapHeight;
    double scale = min(scaleX, scaleY); // Use the smallest scale factor

    // Center the heatmap
    double offsetX = (screenWidth - heatmapWidth * scale) / 2 - minX * scale;
    double offsetY = (screenHeight - heatmapHeight * scale) / 2 - minY * scale;

    // Apply scaling and translation to each cell
    scaledCellVertices = cellVertices.map((cell) {
      return cell.map((vertex) {
        return Offset(
          vertex.dx * scale + offsetX,
          vertex.dy * scale + offsetY,
        );
      }).toList();
    }).toList();

    // Also apply scaling and translation to the centers
    scaledCenters = centers.map((center) {
      return Offset(
        center.dx * scale + offsetX,
        center.dy * scale + offsetY,
      );
    }).toList();

    setState(() {}); // Rebuild the widget with the updated values
  }

  @override
  void dispose() {
    cellPressureSubscription?.cancel();
    super.dispose();
  }
int calculateNormalizationFactor() {
  if (cellPressures.isEmpty) return 1; // Default to 1 if no pressures
  double maxPressure = cellPressures.values.reduce((a, b) => a > b ? a : b);
  return (maxPressure * 6.89).toInt(); 
}
 //String? _selectedScale;
  @override
  Widget build(BuildContext context) {
   int normalizationFactor = Provider.of<NormalizationProvider>(context).normalizationFactor;
   // int normalizationFactor = calculateNormalizationFactor();
   double currentScale = Provider.of<NormalizationProvider>(context).currentScale;
    String currentScaleString = currentScale.toStringAsFixed(1);
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: HeatMapPainter(
              scaledCellVertices,
              scaledCenters,
              cellNumbers,
              cellPressures,
              normalizationFactor,
            ),
            size: Size.infinite,
          ),
        ),

Container(
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
  decoration: BoxDecoration(
    // color: Colors.blue, // Background color
       //color:  const Color.fromARGB(255, 89, 188, 231),
      color: Color.fromARGB(255, 63, 89, 234),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color:Color.fromARGB(255, 63, 89, 234),)
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: currentScaleString,
      icon: const Icon(Icons.arrow_downward, color: Colors.white),
      style: const TextStyle(color: Colors.white),
      dropdownColor: Color.fromARGB(255, 63, 89, 234),
      onChanged: (String? newValue) {
        if (newValue != null) {
          Provider.of<NormalizationProvider>(context, listen: false)
              .setNormalizationFactor(double.parse(newValue));
        }
      },
      items: ['1.0', '1.5', '2.0'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('Scale $value',style: TextStyle(fontSize: 24),),
        );
      }).toList(),
    ),
  ),
)
      ],
    );
  }
}


class HeatMapPainter extends CustomPainter {
  final List<List<Offset>> cellVertices;
  final List<Offset> centers;
  final List<int> cellNumbers;
  final Map<int, double> cellPressures;
 final int normalizationFactor;

  HeatMapPainter(
    this.cellVertices,
    this.centers,
    this.cellNumbers,
    this.cellPressures,
    this.normalizationFactor,
  );

@override
void paint(Canvas canvas, Size size) {
  // Ensure there are vertices to process
  if (cellVertices.isEmpty) return;

  // Calculate bounds
  double minX = cellVertices.expand((e) => e).map((v) => v.dx).reduce(min);
  double maxX = cellVertices.expand((e) => e).map((v) => v.dx).reduce(max);
  double minY = cellVertices.expand((e) => e).map((v) => v.dy).reduce(min);
  double maxY = cellVertices.expand((e) => e).map((v) => v.dy).reduce(max);

  // Calculate width and height based on boundaries
  double width = maxX - minX;
  double height = maxY - minY;

  // Scale to fit the size while keeping aspect ratio
  double scaleX = (size.width * 0.9) / width; // 90% of width to add padding
  double scaleY = size.height / height;
  double scale = min(scaleX, scaleY);

  // Center the heatmap on the canvas
  double offsetX = (size.width - width * scale) / 2;
  double offsetY = (size.height - height * scale) / 2;
  double centerX = size.width / 2;
  double centerY = size.height / 2;

  // Apply horizontal and vertical flip transformation
  canvas.translate(size.width / 2, size.height / 2);
  canvas.scale(-1, -1); // Flip horizontally and vertically
  canvas.translate(-size.width / 2, -size.height / 2);

  // Translate to center
  canvas.translate(centerX, centerY);

  // Rotate the canvas around the new center
  canvas.rotate(pi / 2);

  // Translate back after rotation
  canvas.translate(-centerX, -centerY);

  final paint = Paint()..style = PaintingStyle.fill;

  // Process each cell and apply color based on pressure
  for (int i = 0; i < cellVertices.length; i++) {
    final cellNumber = cellNumbers[i];
    final pressureValue = cellPressures[cellNumber] ?? 0;
    final convertedPressure = pressureValue * 6.89; // Conversion factor

    paint.color = getColorFromPressure(convertedPressure);

    // Create the path for each cell, scale and translate vertices
    final path = Path()
      ..addPolygon(
          cellVertices[i].map((vertex) {
            return Offset(
              (vertex.dx - minX) * scale + offsetX,
              (vertex.dy - minY) * scale + offsetY
            );
          }).toList(),
          true);

    canvas.drawPath(path, paint);
  }
}

  Color getColorFromPressure(double pressure) {
    double normalizedPressure = pressure / normalizationFactor;

    // If pressure is greater than 1, set to dark red
    if (normalizedPressure > 1) {
      return const Color.fromARGB(255, 255, 0, 0); // Dark Red
    }
    // If pressure is less than 0, set to blue
    else if (normalizedPressure < 0) {
      return const Color(0xFF0000FF); // Blue
    }

    // Updated color scheme spectrum
    const List<Color> heatmapColors = [
      
      Color(0xFF00007F), // Dark Blue
      Color(0xFF0000FF), // Blue
      Color(0xFF007FFF), // Azure
      Color(0xFF00FFFF), // Cyan
      Color(0xFF7FFF7F), // Green
      Color(0xFFFFFF00), // Yellow
      Color(0xFFFFA500), // Orange
      Color(0xFFFF4500), // Red
      Color.fromARGB(255, 255, 0, 0), // Dark Red
    ];

    List<double> stops = List.generate(
        heatmapColors.length, (index) => index / (heatmapColors.length - 1));

    int index = stops.indexWhere((stop) => stop >= normalizedPressure);
    if (index == -1) {
      return heatmapColors.last; // If pressure is beyond the scale
    } else if (index == 0) {
      return heatmapColors.first; // If pressure is below the scale
    }

    double t = (normalizedPressure - stops[index - 1]) /
        (stops[index] - stops[index - 1]);
    return Color.lerp(heatmapColors[index - 1], heatmapColors[index], t) ??
        Colors.black;
  }

// Color getColorFromPressure(double pressure) {
//   // Normalize the pressure value by dividing by 14.0
//   double normalizedPressure = pressure / 10.0;

//   // Define colors for specific pressure values
//   Color darkRed = const Color.fromARGB(255, 255, 0, 0);
//   Color blue = const Color(0xFF0000FF);

//   // Return dark red if the pressure is greater than 1
//   if (normalizedPressure > 1) {
//     return darkRed;
//   }
//   // Return blue if the pressure is less than 0
//   if (normalizedPressure < 0) {
//     return blue;
//   }

//   // List of colors representing different pressure levels
//   const List<Color> heatmapColors = [
//     Color(0xFF00007F), // Dark Blue
//     Color(0xFF0000FF), // Blue
//     Color(0xFF007FFF), // Azure
//     Color(0xFF00FFFF), // Cyan
//     Color(0xFF7FFF7F), // Green
//     Color(0xFFFFFF00), // Yellow
//     Color(0xFFFFA500), // Orange
//     Color(0xFFFF4500), // Red
//     Color.fromARGB(255, 255, 0, 0), // Dark Red
//   ];

//   // Calculate the position in the heatmapColors list
//   double scaledPressure = normalizedPressure * (heatmapColors.length - 1);
//   int lowerIndex = scaledPressure.floor();
//   int upperIndex = scaledPressure.ceil();

//   // Interpolate between the two nearest colors
//   double t = scaledPressure - lowerIndex;
//   return Color.lerp(heatmapColors[lowerIndex], heatmapColors[upperIndex], t) ?? Colors.black;
// }

  void drawText(Canvas canvas, String text, Offset position) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

@override
  bool shouldRepaint(CustomPainter oldDelegate) => true;





}
