# QDot
## Server framework in Dart
<img src="https://github.com/mdb2301/QDot/blob/master/static/qdot.jpg?raw=true" alt="Logo" style="width:450px;"/>

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

2. Open terminal in project folder and run: <br/>
`git clone https://github.com/mdb2301/QDot.git`

3. Update project level `pubspec.yaml`:
```yaml
environment:
  sdk: ^2.17.6
  
dependencies: 
  qdot: 0.0.1
``` 

4. Create HTML templates named `index.html` and `test.html`.

5. Put HTML templates in `{project-name}/templates/` and static files in `{project-name}/static/`

6. Refer `example.dart` for usage
