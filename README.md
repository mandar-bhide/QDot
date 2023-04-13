# QDot
## Server framework in Dart
<img src="https://github.com/mdb2301/QDot/raw/master/static/qdot.jpg?raw=true" alt="Logo" style="width:450px;"/>

## Provides:
- Web endpoints
- File server
- RESTful endpoints

## Supports:
- Redirection
- Rendering templates
- Query and path parameters in URL

## How to use:
1. Create the project folder with `pubspec.yaml` and `main.dart` in it. <br/>

2. Update project level `pubspec.yaml`:
```yaml
environment:
  sdk: ^2.17.6
  
dependencies: 
  qdot: 0.0.3
``` 

3. Create HTML templates named `index.html` and `test.html`.

4. Put HTML templates in `{project-name}/templates/` and static files in `{project-name}/static/`

5. To run project, open terminal in the project folder and run:
```
dart main.dart
```
6. Optionally:
```
dart main.dart --host [hostname] --port [port]
```
8. Refer `example.dart` for further usage
