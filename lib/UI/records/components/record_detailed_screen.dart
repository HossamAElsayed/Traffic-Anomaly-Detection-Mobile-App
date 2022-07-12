import 'dart:io';

import 'package:flutter/material.dart';

class RecordDetailsScreen extends StatelessWidget {
  final String id;
  final String latitude;
  final String longitude;
  final String speed;
  final String date;
  final String time;
  final String loc;
  final bool state;
  const RecordDetailsScreen({
    Key? key,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.date,
    required this.time,
    required this.loc,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: kDefaultMargin),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
              child: _buildBackArrow(context),
            ),
            const SizedBox(width: kDefaultMargin),
            _buildBasicInfo(),
          ],
        ),
        const SizedBox(height: kLargeMargin),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kLargeMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabBarPage(title: "Specifications", isCurrentPage: true),
              // _buildTabBarPage(title: "Flight History", isCurrentPage: false),
            ],
          ),
        ),
        Expanded(
          child: _buildPages(context),
        ),
      ],
    );
  }

  Widget _buildBackArrow(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(kDefaultMargin),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kBackgroundButtonColor, width: 2.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(kSmallMargin),
          decoration: const BoxDecoration(
            color: kBlackColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPages(BuildContext context) {
    return PageView(
      children: [
        _buildSpecificationPage(Specification(
            latitude: latitude,
            longitude: longitude,
            time: time,
            vehicleSpeed: speed)),
        Container(),
      ],
    );
  }

  Widget _buildTabBarPage(
          {required String title, bool isCurrentPage = false}) =>
      Column(
        children: [
          Text(title,
              style: kSubTitleTextStyle.copyWith(
                color: isCurrentPage
                    ? kSubTitleTextStyle.color
                    : kUnselectedButtonBarColor,
              )),
          const SizedBox(height: kSmallMargin),
          Container(
              height: 5.0,
              width: 25.0,
              decoration: BoxDecoration(
                color: isCurrentPage ? kAccentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              )),
          const SizedBox(height: kLargeMargin),
        ],
      );

  Widget _buildBasicInfo() {
    bool _isUploaded = true;
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            id,
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: kSmallMargin),
          Row(
            children: [
              Icon((state) ? Icons.done : Icons.local_fire_department),
              const SizedBox(width: 5.0),
              Text(
                (state) ? 'Uploaded' : 'Local',
                style: TextStyle(
                    color: (state) ? Colors.green : Colors.red, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSpecificationPage(Specification specification) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kLargeMargin),
          child: Column(
            children: [
              Row(
                children: [
                  PropertyWidget(
                      icon: Icons.location_searching,
                      title: "Latitude",
                      subtitle: specification.latitude),

                  PropertyWidget(
                      icon: Icons.compare_arrows_rounded,
                      title: "Longitude",
                      subtitle: specification.longitude),
                  // Container(),
                ],
              ),
              const SizedBox(height: kLargeMargin),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PropertyWidget(
                      icon: Icons.whatshot,
                      title: "Record Time",
                      subtitle: specification.time),

                  PropertyWidget(
                      icon: Icons.speed,
                      title: "Vehicle Speed",
                      subtitle: specification.vehicleSpeed),
                  // Container(),
                ],
              ),
              const SizedBox(height: kDefaultMargin),
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: Image.file(File(loc)),
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              )),
        )),
        const SizedBox(height: kLargeMargin),
        // PrimaryButton(text: 'Fly Now', onPressed: () {}),
        const SizedBox(height: kDefaultMargin),
      ],
    );
  }
}

class PropertyWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PropertyWidget(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(kSmallMargin),
            decoration: BoxDecoration(
              color: kBackgroundButtonColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: kSmallMargin),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kSmallTextStyle),
                const SizedBox(height: 4.0),
                Text(subtitle,
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// COLORS
const kBackgroundColor = Color(0xFFFFFFFF);
const kAccentColor = Color(0xFFFD1716);
const kUnselectedButtonBarColor = Color(0xFF7E8083);
const kBackgroundButtonColor = Color(0xFFF3F3F3);
const kBlackColor = Color(0xFF252525);

// MARGINS, SIZES...
const kDefaultMargin = 16.0;
const kLargeMargin = kDefaultMargin * 2;
const kSmallMargin = kDefaultMargin / 2;
const kBottomNavHeight = 60.0;

// TEXTS
const kTitleTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const kSubTitleTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 20.0,
  color: Colors.black,
);

const kNormalTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 16.0,
);

const kSmallTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 10.0,
);

class Specification {
  final String latitude;
  final String longitude;
  final String vehicleSpeed;
  final String time;
  Specification({
    required this.latitude,
    required this.longitude,
    required this.vehicleSpeed,
    required this.time,
  });
}
