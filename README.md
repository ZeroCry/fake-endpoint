# fake-endpoint
Aplicacion que permite simular un endpoint REST, mediante el uso de templates json


## configuracion inicial

### Clonar el proyecto

```
git clone https://github.com/joelibaceta/fake-endpoint.git
```

### Instalar dependencias

```
  cd fake-endpoint
```
```
  gem install bunlder
```
```
  bundle install
```
## iniciar el servidor

```
  ruby app.rb
```
Cuando se vea el mensaje 

**http://localhost:4567/v1/sample.json?title=hello**

```
[2016-05-16 13:10:21] INFO  WEBrick 1.3.1
[2016-05-16 13:10:21] INFO  ruby 2.3.1 (2016-04-26) [x86_64-darwin15]
== Sinatra (v1.4.7) has taken the stage on 4567 for development with backup from WEBrick
[2016-05-16 13:10:21] INFO  WEBrick::HTTPServer#start: pid=1698 port=4567
```

Se habra iniciado un servidor web en el puerto 4567 al que se puede acceder desde localhost:4567


## forma de uso 

Todo request realizado a localhost:4567 sera recibido por el servidor web siguiendo los siguientes pasos.

1. Recibir request (GET / POST) y parsear url para obtener ruta y parametros 
2. Con la ruta se busca de forma local el archivo json de respuesta por ejemplo, para un request a /v1/sample.json se buscara localmente un archivo sample.json en la carpeta v1 bajo el directorio base.

![GitHub Logo](/doc/json_dir.png) 

> Los archivos deben ser agregados en la carpeta raiz segun la ruta en la url pero en una estructura fisica de directorios.

3. Los archivos son leidos y las etiquetas reemplazadas por los valores suministrados en el request, por ejemplo en el siguiente archivo JSON  **sample.json**

```
{
    "glossary": {
        "title": "<title>  </title>",
        "GlossDiv": {
            "title": "<sample> a Default value </sample>",
            "GlossList": {
                "GlossEntry": {
                    "Title": "<title>  </title>",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
```

Las etiquetas <title> </title> y su contenido seran reemplazadas por el contenido del parametro con el mismo nombre, recibido en el request en caso no se reciba ningun parametro la etiqueta sera reemplazada por el valor por default contenido en la etiqueta, por ejemplo si el parametro title es igual a "hello world" el resultado sera

```
{
    "glossary": {
        "title": "hello world",
        "GlossDiv": {
            "title": "a  Default value",
            "GlossList": {
                "GlossEntry": {
                    "Title": "hello world",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
```




 