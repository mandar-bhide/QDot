class URIHandler{
  static RegExp generateRegex(String template){
    if(template==''||template=='/') return RegExp(r'^/$');

    final explode = template.split('/');
    var finalRegex = [];
    for(String s in explode){
      if(s.startsWith('<')){
        s = s.replaceAll('<','').replaceAll('>','');
        switch(s.split(':')[0]){
          case 'num':
            finalRegex.add(r'[0-9]+.*[0-9]*');
            break;
          default:
            finalRegex.add(r'[A-Za-z0-9]+');
            break;
        }
      }else{
        finalRegex.add(s);
      }
    }
    finalRegex.removeAt(0);
    return RegExp(r'\/'+finalRegex.join('/'));
  }

  static Map<String,dynamic> parsePath(String template,String path){
    final templateparts = template.split('/');
    final pathparts = path.split('/');
    final params = Map<String,dynamic>();
    if(templateparts.length==pathparts.length){
      for(int i=0;i<templateparts.length;i++){
        if(templateparts[i].startsWith('<')){
          final s = templateparts[i].replaceAll('<','').replaceAll('>','').split(':');
          switch(s[0]){
            case 'num':
              final x = int.tryParse(pathparts[i]);
              params[s[1]] = x!=null?x:double.tryParse(pathparts[i]);
              break;
            default:
              params[s[1]] = pathparts[i];
              break;
          }
        }
      }
    }
    return params;
  }
}