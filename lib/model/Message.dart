
class Message{
  String _userId;
  String _message;
  String _urlImage;
  String _type;
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

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }


}