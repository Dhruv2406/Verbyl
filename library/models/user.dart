class VerbylUser {
  String name = "";
  String email = "";
  String location = "";
  int avatarIndex = 0;
  int followingArtists = 0;
  int playlists = 0;

  VerbylUser();

  VerbylUser.named({
    required this.name,
    required this.email,
    required this.location,
    required this.avatarIndex,
    required this.followingArtists,
    required this.playlists
  }) {
    name = name;
    email = email;
    location = location;
    avatarIndex = avatarIndex;
    followingArtists = followingArtists;
    playlists = playlists;
  }
}
