class Repo {
  final int id;
  final String name;
  final String description;
  final String owner;
  bool isFavorite;

  Repo({ required this.id, required this.name, required this.description, required this.owner, this.isFavorite = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'owner': owner,
    'isFavorite': isFavorite,
  };

  static Repo fromJson(Map<String, dynamic> json) => Repo(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    owner: json['owner'],
    isFavorite: json['isFavorite'],
  );
}