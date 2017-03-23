
createElememt = (name, props, children...) ->
  [name, props, children]

div = (props, children...) -> createElememt 'div', props, children...
text = (props, children...) -> createElememt 'text', props, children...
input = (props, children...) -> createElememt 'input', props, children...
scroller = (props, children...) -> createElememt 'scroller', props, children...

createTree = (tree, domRefs) ->
  # console.log '\n\nExpanding:', JSON.stringify(tree)
  [name, props, children] = tree
  element = document.createElement name,
    style: props.style
    attr: props.attr
  if props.event
    for key, value of props.event
      element.addEvent key, value
  if children?
    # console.log 'CHILDREN:', JSON.stringify(children)
    for child in children
      childElement = createTree child, domRefs
      # console.log '\n\nChild to append:', JSON.stringify(childElement)
      element.appendChild childElement
  if props.ref?
    domRefs[props.ref] = element
  element

exports.div = div
exports.text = text
exports.input = input
exports.scroller = scroller

exports.createElememt = createElememt
exports.createTree = createTree
