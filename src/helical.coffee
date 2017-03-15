`// { "framework": "Vanilla" }
`

# global sharing

doc = weex.document

# framework

domRefs = {}

helicalCreateElememt = (name, props, children...) ->
  [name, props, children]

helicalExpandTree = (tree) ->
  # console.log '\n\nExpanding:', JSON.stringify(tree)
  [name, props, children] = tree
  element = doc.createElement name,
    style: props.style
    attr: props.attr
  if props.event
    for key, value of props.event
      element.addEvent key, value
  if children?
    # console.log 'CHILDREN:', JSON.stringify(children)
    for child in children
      childElement = helicalExpandTree child
      # console.log '\n\nChild to append:', JSON.stringify(childElement)
      element.appendChild childElement
  if props.ref?
    domRefs[props.ref] = element
  element

div = (props, children...) -> helicalCreateElememt 'div', props, children...
text = (props, children...) -> helicalCreateElememt 'text', props, children...
input = (props, children...) -> helicalCreateElememt 'input', props, children...

# initial variables

modal = weex.requireModule 'modal'

deviceWidth = weex.config.env.deviceWidth
deviceHeight = weex.config.env.deviceHeight

height = 750 / deviceWidth * deviceHeight

store =
  draft: ''
  tasks: []

# styles

styleBody =
  alignItems: 'center'
  justifyContent: 'center'

styleContainer =
  backgroundColor: '#eeeeee'
  width: 750
  flex: 1

styleHeader =
  backgroundColor: '#eeeeee'
  height: 80
  flexDirection: 'row'

styleInput =
  color: '#333333'
  backgroundColor: '#dddddd'
  height: 60
  lineHeight: 60
  paddingLeft: 16
  paddingRight: 16
  flex: 1

styleButton =
  width: 160
  height: 60
  backgroundColor: '#aaaaff'
  color: 'white'
  textAlign: 'center'
  fontSize: 32
  paddingTop: 8

styleContent =
  paddingTop: 8
  paddingBottom: 8

# events

onDraft = (event) ->
  store.draft = event.target.attr.value

onAdd = (event) ->
  store.draft = ''
  store.tasks.push id: Date.now(), done: 'false', text: store.draft
  # DOM operations
  console.log 'DOM operations!!!'
  domRefs.input.setAttr 'value', ''
  domRefs.content.setAttr 'value', JSON.stringify(store.tasks)

# DOM tree

mainTree = ->
  div style: styleBody,
    div style: styleContainer,
      div style: styleHeader,
        input
          ref: 'input'
          style: styleInput
          attr: {value: '', placeholder: 'Some task...'}
          event: {input: onDraft}
        text
          style: styleButton
          attr: {value: 'Add task'}
          event: {click: onAdd}
      text
        ref: 'content'
        style: styleContent
        attr: {value: JSON.stringify(store.tasks)}

# mounting document

doc.documentElement.appendChild (helicalExpandTree mainTree())
