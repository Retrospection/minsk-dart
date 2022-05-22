

class TextSpan {
  int _start;
  int _length;

  TextSpan(this._start, this._length);

  int get start => _start;
  int get end => _start + _length;
  int get length => _length;
}