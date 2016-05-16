# fake-endpoint
Aplicacion que permite simular un endpoint REST, mediante el uso de templates json, usando Faker como generador de informacion falsa, ver [Faker](https://github.com/stympy/faker) para conocer los metodos ruby disponibles para la generacion de contenido.


## configuracion inicial

### Clonar el proyecto

```bash
git clone https://github.com/joelibaceta/fake-endpoint.git
```

### Instalar dependencias

```bash
  cd fake-endpoint
```
```bash
  gem install bunlder
```
```bash
  bundle install
```
## iniciar el servidor

```bash
  ruby app.rb
```
Cuando se vea el mensaje 

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

3. Los archivos son leidos
  -Las etiquetas reemplazadas por los valores suministrados en el request
  -El texto encerrado en -- -- es evaluado por Ruby
   
  Por ejemplo en el siguiente archivo JSON  **sample.json**

  ```html
  {
      "glossary": {
          "title": "<title>  </title>",
          "author": "--Faker::Name.name--"
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
                          "definition": "--Faker::Lorem.paragraph(<ndefpar>2</ndefpar>)--"
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
  
  > Si el valor -- -- se encuentra dentro de una etiqueta el resultado de la evaluacion de codigo ruby solo sera visible cuando no se reciba un parametro de etiqueta.
  > Es posible usar etiquetas dentro del codigo -- -- con el fin de recibir parametros para las funciones ruby de forma dinamica.
 
  
  Ejemplo: si el parametro title es igual a "hello" el resultado sera

  **http://localhost:4567/v1/sample.json?title=hello&ndefpar=5**

  ```json
  {  
     "glossary":{  
        "title":"hello",
        "author":"Hoyt Hagenes",
        "GlossDiv":{  
           "title":" a Default value ",
           "GlossList":{  
              "GlossEntry":{  
                 "Title":"hello",
                 "SortAs":"SGML",
                 "GlossTerm":"Standard Generalized Markup Language",
                 "Acronym":"SGML",
                 "Abbrev":"ISO 8879:1986",
                 "GlossDef":{  
                    "definition":"Dolore maiores harum occaecati. Cumque consequatur dolor. Et doloribus et rerum. Soluta tempore voluptas quisquam explicabo deserunt enim architecto. Exercitationem aliquid doloremque est voluptates. Officiis totam sit sunt quis corrupti hic ea.",
                    "para":"A meta-markup language, used to create markup languages such as DocBook.",
                    "GlossSeeAlso":[  
                       "GML",
                       "XML"
                    ]
                 },
                 "GlossSee":"markup"
              }
           }
        }
     }
  }
  ```

#### Que ha sucedido ?

- Las etiquetas `<title> </title>` han sido reemplazadas por el valor del parametro GET title
- La etiqueta `<sample> </sample>` ha sido reemplazada por su valor por defecto al no encontrarse un parametro con un nuevo valor.
- El codigo **--Faker::Name.name--** es reemplazado por su valor luego de ser evaluado como codigo Ruby tomando como parametro el valor del parametro ndefpar recibido y reemplazado por la etiqueta `<ndefpar></ndefpar>`

> Ver [Faker](https://github.com/stympy/faker) para conocer los metodos ruby disponibles.

 
## rspec

Para usar este snippet con rspec es necesario agregar al Gemfile

```ruby
gem 'webmock', require: false
```

Insertar el codigo de app.rb en una clase que herede de Sinatra::Base

```ruby
class FakeEndpoint < Sinatra::Base
  ## El codigo va aqui
end
```
  
Y agregar la configuracion 

```ruby
RSpec.configure do |config| 

  config.before(:each) do
    stub_request(:any, /www.la_url_de_tu_endpoint/).to_rack(FakeEndpoint)
  end

end
```
