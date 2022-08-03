# QDot
## Server framework in Dart
<img src="static/qdot.jpg" alt="Logo" style="width:450px;"/>

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
```
dependencies: 
  qdot:
    path: ./QDot
``` 

4. Put HTML templates in `{project-name}/templates/` and static files in `{project-name}/static/`

5. Refer `example.dart` for usage