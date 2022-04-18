class Playlist{
  int? pid;
  String? name;
  String? creationDate;

  Playlist({
    this.pid,
    this.name,
    this.creationDate
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    pid: int.parse(json["PId"]),
    name: json["Name"],
    creationDate: json["CreationDate"],
  );
}
