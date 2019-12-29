
class Conversation {
    String _name;
    String _message;
    String _pathPhoto;


    Conversation(this._name, this._message, this._pathPhoto);

    String get name => _name;

    set name(String value) {
        _name = value;
    }

    String get message => _message;

    String get pathPhoto => _pathPhoto;

    set pathPhoto(String value) {
        _pathPhoto = value;
    }

    set message(String value) {
        _message = value;
    }


}