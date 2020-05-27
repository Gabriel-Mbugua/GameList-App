class Game {
  final int id;
  final String name;
  final String released;
  final String imageUrl;
  final double rating;
  final int playtime;

  Game(
      {this.id, this.name, this.released, this.imageUrl, this.rating, this.playtime});

  factory Game.fromJson(Map<String, dynamic> json) =>
      Game(
          id: json['id'],
          name: json['name'],
          released: json['released'],
          imageUrl: json['background_image'],
          rating: json['rating'],
          playtime: json['playtime']
      );
}
