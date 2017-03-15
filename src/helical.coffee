`// { "framework": "Vanilla" }
`

doc = weex.document
deviceWidth = weex.config.env.deviceWidth
deviceHeight = weex.config.env.deviceHeight

height = 750 / deviceWidth * deviceHeight

container = doc.createElement 'div',
  classStyle:
    backgroundColor: '#eeeeee'
    width: 750
    flex: 1

body = doc.createElement 'div',
  classStyle:
    alignItems: 'center'
    justifyContent: 'center'

input = doc.createElement 'input',
  attr:
    value: 'Demo'
  classStyle:
    color: 'blue'
    backgroundColor: '#aaaaaa'
    height: 60
    lineHeight: 60
    paddingLeft: 16
    paddingRight: 16

title = doc.createElement 'title',
  attr:
    text: 'Text'
    value: 'Value'
    innerText: 'innerText'

text = doc.createElement 'text',
  attr:
    value: 'Hello World'
  classStyle:
    fontSize: 48, color: 'red'

container.appendChild input
container.appendChild title
container.appendChild text

body.appendChild container

doc.documentElement.appendChild body

body.addEvent 'click', ->
  text.setAttr('value', 'Hello Weex')
