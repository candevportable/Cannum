
class Message{
  String userId;
  String message;
  String urlImage;
  String type;
  DateTime _time;

  Message();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "userId": this.userId,
      "message": this.message,
      "urlImage": this.urlImage,
      "type": this.type,
      "time": this.time
    };
    return map;
  }

  DateTime get time => _time;

  set time(DateTime value) {
    _time = value.toUtc();
  }

}