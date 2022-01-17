library extra_key_value;

RegExp CODE_REG_EXP = RegExp(r'\[code=.*]');

enum ContentType {
  none,
  key,
  value
}

class ExtractedHeader {
  ContentType type;
  String header;
  String code;


  ExtractedHeader(this.type, this.header, this.code);

  @override
  String toString() {
    return 'ExtractedHeader{type: $type, header: $header, code: $code}';
  }
}

ExtractedHeader convertToExtractedHeader(String header){
  Match? match = CODE_REG_EXP.firstMatch(header);
  if(match == null){
    return ExtractedHeader(ContentType.none, header, '');
  }

  String code = header.substring(match.start + 6, match.end - 1);
  if(code == 'key'){
    return ExtractedHeader(ContentType.key, header, '');
  }

  return ExtractedHeader(ContentType.value, header, code);
}


