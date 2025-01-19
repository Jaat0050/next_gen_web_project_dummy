import 'package:flutter/material.dart';

import 'constant_image.dart';

class ConstantsData {
  // MY STORE TABS
  static List<String> storeTabs = ["All Products", "Collections", "My Store"];
  // Home Data
  static List<String> trendingProducts = [
    ConstantImage.product1,
    ConstantImage.product2,
    ConstantImage.product3,
    ConstantImage.product4,
  ];
  static List<String> myProducts = [
    ConstantImage.product5,
    ConstantImage.product6,
    ConstantImage.product7,
    ConstantImage.product8,
  ];
  static List<String> brandImages = [
    ConstantImage.myntra,
    ConstantImage.amazon,
    ConstantImage.hm,
    ConstantImage.polo,
    ConstantImage.biba
  ];

  // Collections Data
  static List<String> collection1 = [
    ConstantImage.card4,
    ConstantImage.card3,
    ConstantImage.card2,
    ConstantImage.card1
  ];
  static List<String> collection2 = [
    ConstantImage.card8,
    ConstantImage.card7,
    ConstantImage.card6,
    ConstantImage.card5
  ];
  static List<String> collection3 = [
    ConstantImage.card12,
    ConstantImage.card11,
    ConstantImage.card10,
    ConstantImage.card9
  ];
  static List<String> collection4 = [
    ConstantImage.card16,
    ConstantImage.card15,
    ConstantImage.card14,
    ConstantImage.card13
  ];
  static List<String> mensInnerwear = [
    ConstantImage.mensInnerwear4,
    ConstantImage.mensInnerwear3,
    ConstantImage.mensInnerwear2,
    ConstantImage.mensInnerwear1
  ];

  static List<String> denims = [ConstantImage.denims4, ConstantImage.denims3, ConstantImage.denims2, ConstantImage.denims1];
  // Filter Data
  static List sortBy = [
    // {
    //   "value": false,
    //   "title": "Recommended",
    //   "id": "recommended",
    // },
    {"value": false, "title": "Newest", "id": "newest",},
    {"value": false, "title": "Lowest Commission", "id": "lowestCommission",},
    {"value": false, "title": "Highest Commission", "id" : "highestCommission"},
  ];

  static List colour = [
    {"color": Colors.white, "title": "White", "value": false, "count": 4,"id":"white"},
    {"color": Colors.black, "title": "Black", "value": false, "count": 17,"id":"black"},
    {"color": Colors.blue, "title": "Blue", "value": false, "count": 12,"id":"blue"},
    {"color": Colors.green, "title": "Green", "value": false, "count": 8,"id":"green"},
    {"color": Colors.grey, "title": "Grey", "value": false, "count": 36,"id":"grey"},
    //{"color": const Color(0XFF23272E), "title": "Multi", "value": false, "count": 113,"id":"black"},
    {"color": Colors.pink, "title": "Pink", "value": false, "count": 2,"id":"pink"},
  ];

  static List material = [
    {"value": false, "title": "Cotton", "count": 4},
    {"value": false, "title": "Linen", "count": 17},
    {"value": false, "title": "Fleece", "count": 12},
    {"value": false, "title": "Silk", "count": 8},
    {"value": false, "title": "Denim", "count": 36},
  ];
}
