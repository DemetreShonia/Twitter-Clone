import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers; // in form of user ids
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final bool isTwitterBlue;
  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.isTwitterBlue,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'followers': followers,
      'following': following,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'bio': bio,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      followers: List<String>.from(map['followers'] as List<String>),
      following: List<String>.from(map['following'] as List<String>),
      profilePic: map['profilePic'] as String,
      bannerPic: map['bannerPic'] as String,
      uid: map['\$id'] as String,
      bio: map['bio'] as String,
      isTwitterBlue: map['isTwitterBlue'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio &&
        other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        isTwitterBlue.hashCode;
  }
}
