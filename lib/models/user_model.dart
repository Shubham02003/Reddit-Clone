import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String uid;
  //if guest or not
  final bool isAuthenticate;
  final String banner;
  final String profilePic;
  final int karma;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.uid,
    required this.isAuthenticate,
    required this.banner,
    required this.profilePic,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? uid,
    bool? isAuthenticate,
    String? banner,
    String? profilePic,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isAuthenticate: isAuthenticate ?? this.isAuthenticate,
      banner: banner ?? this.banner,
      profilePic: profilePic ?? this.profilePic,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'isAuthenticate': isAuthenticate,
      'banner': banner,
      'profilePic': profilePic,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticate: map['isAuthenticate'] ?? false,
      banner: map['banner'] ?? '',
      profilePic: map['profilePic'] ?? '',
      karma: map['karma']?.toInt() ?? 0,
      awards: List<String>.from(map['awards']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, isAuthenticate: $isAuthenticate, banner: $banner, profilePic: $profilePic, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.uid == uid &&
        other.isAuthenticate == isAuthenticate &&
        other.banner == banner &&
        other.profilePic == profilePic &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uid.hashCode ^
        isAuthenticate.hashCode ^
        banner.hashCode ^
        profilePic.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}
