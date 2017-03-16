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

# utils

refId = 0
getId = ->
  refId += 1
  refId

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
  backgroundColor: '#ddd'

styleTask =
  height: 60
  width: 750
  backgroundColor: '#afa'
  flexDirection: 'row'

styleDone =
  width: 48
  height: 48
  backgroundColor: '#8ff'

styleTaskText =
  flex: 1
  height: 48

styleRemove =
  width: 48
  height: 48
  backgroundColor: '#fcc'

# frequent DOM operations

getRaw = ->
  store.tasks.map((task) -> task.text).join(' | ')

modifyRaw = ->
  console.log 'Raw data', getRaw(), store.tasks
  domRefs.raw.setAttr 'value', getRaw()

# events

onDraft = (event) ->
  store.draft = event.target.attr.value

onAdd = (event) ->
  newTask = id: getId(), done: 'false', text: store.draft
  store.draft = ''
  store.tasks.unshift newTask
  # DOM operations
  console.log 'DOM operations!!!'
  domRefs.input.setAttr 'value', ''
  newElement = helicalExpandTree (taskTree newTask)
  console.log '\nnewElement:', newElement
  domRefs.content.appendChild newElement
  modifyRaw()

onToggle = (event) ->
  console.log 'onToggle', event

onRemove = (taskId) -> (event) ->
  store.tasks = store.tasks.filter (task) -> task.id isnt taskId
  # DOM operations
  taskElement = event.target.parentNode
  taskElement.parentNode.removeChild taskElement
  modifyRaw()

onUpdate = (taskId) -> (event) ->
  console.log 'Update event:', event.target.attr
  newText = event.target.attr.value
  store.tasks = store.tasks.map (task) ->
    if task.id is taskId
      task.text = newText
      task
    else
      task
  # DOM operations
  modifyRaw()

# DOM tree

taskTree = (task) ->
  div style: styleTask,
    div
      style: styleDone
      event: {click: onToggle}
    input
      attr:
        value: task.text
        placeholder: 'Empty task'
      style: styleTaskText
      event: {input: onUpdate(task.id)}
    div
      style: styleRemove
      event: {click: onRemove task.id}

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
        ref: 'raw'
        attr: {value: getRaw()}
        style: styleContent
      div
        ref: 'content'
        style: styleContent

# mounting document

doc.documentElement.appendChild (helicalExpandTree mainTree())
