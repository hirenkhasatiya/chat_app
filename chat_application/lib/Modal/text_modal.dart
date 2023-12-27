class chatModal {
  String msj, type;
  DateTime time;

  chatModal({required this.msj, required this.time, required this.type});

  factory chatModal.fromMap({required Map data}) => chatModal(
        msj: data['msg'],
        time: DateTime.fromMillisecondsSinceEpoch(data['time']),
        type: data['type'],
      );

  Map<String, dynamic> get toMap => {
        'msg': msj,
        'type': type,
        'time': time.millisecondsSinceEpoch,
      };
}
