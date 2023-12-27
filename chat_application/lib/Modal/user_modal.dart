class UserModal {
  String id;
  String password, email, img, username;

  UserModal(
      {required this.id,
      required this.email,
      required this.password,
      required this.username,
      required this.img});

  factory UserModal.fromMap({required Map data}) => UserModal(
        id: data['id'],
        email: data['email'],
        username: data['username'],
        password: data['password'],
        img: data['img'],
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'email': email,
        'password': password,
        'img': img,
        'username': username
      };
}
