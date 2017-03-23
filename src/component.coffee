
{div} = require './core'

class Component
  constructor: (props) ->
    @children = {}
    @domRefs = {}
    @props = props
    @state = @initState props

    element = @render props, @state
    @virtualElement = createTree element
    @mountChildren()

  initState: (props) ->
    {}

  destroy: ->
    for k, child of @children
      child.destroy()

    @children = null
    @domRefs = null

  render: (props) ->
    div {}

  mountChildren: ->
