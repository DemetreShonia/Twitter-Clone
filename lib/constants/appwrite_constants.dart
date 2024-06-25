class AppwriteConstants {
  static final String dataBaseId = '667827f600024069ce00';
  static final String projectId = '667827bc0019d4147c3c';
  static final String endPoint = 'https://hoppla.autos/v1';
  static const String usersCollection = '667827fb00386a0bc18f';
  static const String tweetsCollection = '667af3320036176bc417';
  static const String imagesBucket = "667b06830025d4b9b4ce";

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
