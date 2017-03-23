
# global sharing

# utils

refId = 0
getId = ->
  refId += 1
  refId

# initial variables

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
  paddingTop: 16
  paddingLeft: 24
  paddingRight: 24

styleContainer =
  backgroundColor: '#fafafa'
  width: 702
  flex: 1

styleHeader =
  height: 80
  flexDirection: 'row'
  marginBottom: 16

styleInput =
  color: '#333333'
  backgroundColor: '#eee'
  height: 80
  lineHeight: 80
  paddingLeft: 16
  paddingRight: 16
  flex: 1
  marginRight: 16

styleButton =
  width: 160
  height: 80
  lineHeight: 80
  backgroundColor: '#aaaaff'
  color: 'white'
  textAlign: 'center'
  fontSize: 32

styleContent =
  flexDirection: 'column'
  alignItems: 'stretch'
  maxHeight: 800
  overflow: 'auto'
  flex: 0

styleRaw =
  color: '#aaa'
  fontSize: 24

styleTask =
  height: 80
  width: 702
  backgroundColor: '#fff'
  flexDirection: 'row'
  marginBottom: 16

styleDone =
  width: 80
  height: 80
  backgroundColor: '#6f6'
  flexShrink: 0

styleTaskText =
  flex: 1
  height: 80
  lineHeight: 80
  marginLeft: 16
  marginRight: 16

styleRemove =
  width: 80
  height: 80
  backgroundColor: '#f88'

styleInfo =
  flexDirection: 'row'
  justifyContent: 'flex-end'

# frequent DOM operations

getRaw = ->
  count = store.tasks.length
  "#{count} tasks"

modifyRaw = ->
  console.log 'Raw data', getRaw(), store.tasks
  domRefs.raw.setAttr 'value', getRaw()

# events

onDraft = (event) ->
  store.draft = event.target.attr.value

onAdd = (event) ->
  _startTime = Date.now()
  newTask = id: getId(), done: 'false', text: store.draft
  store.draft = ''
  store.tasks.unshift newTask
  # DOM operations
  console.log 'DOM operations!!!'
  domRefs.input.setAttr 'value', ''
  newElement = helicalExpandTree (taskTree newTask)
  console.log '\nnewElement:', newElement
  if domRefs.content.children.length is 0
    domRefs.content.appendChild newElement
  else
    anchor = domRefs.content.children[0]
    domRefs.content.insertBefore newElement, anchor
  modifyRaw()
  console.log 'Elapsed time:', (Date.now() - _startTime)

onToggle = (taskId) -> (event) ->
  doneStatus = undefined
  store.tasks.forEach (task) ->
    if task.id is taskId
      task.done = not task.done
      doneStatus = task.done
  # DOM operations
  console.log 'Done status:', doneStatus
  event.target.setStyle 'backgroundColor', (if doneStatus then '#fdd' else '#6f6')

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
      style: Object.assign {}, styleDone
      event: {click: onToggle task.id}
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
      scroller
        ref: 'content'
        style: styleContent
      div
        style: styleInfo
        text
          ref: 'raw'
          attr: {value: getRaw()}
          style: styleRaw

# mounting document

document.documentElement.appendChild (helicalExpandTree mainTree())
