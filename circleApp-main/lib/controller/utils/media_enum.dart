enum MediaType {
  image('image'),
  video('video'),
  audio('audio');

  final String value;

  const MediaType(this.value);

  @override
  String toString() => value;
}
