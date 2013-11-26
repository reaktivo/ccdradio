$ = require '../vendor/jquery-1.10.1.js'

class Main

  cols: null
  content: null
  constructor: ->
    @window = $ window
    @content = $ '#content'
    do @setup_events
    do @animate
    do @layout

  setup_events: =>
    @window.resize @layout
    $('.post').click @show_post
    $('li.programacion a').click @toggleCalendar
  animate: =>


  show_post: (e) =>
    post = $ e.currentTarget
    width = if post.outerWidth() > 280 then 280 else 560
    post.animate { width }
    $('.post').not(post).animate(width: 280)

  layout: =>
    @cols or= $('.col')
    @headerHeight or= $('body > header').outerHeight()
    height = @viewport().height - @headerHeight
    @cols.css { height }
    width = 0
    @cols.each -> width += $(this).outerWidth(yes)
    @content.css { width }

  toggleCalendar: (e) =>
    e.preventDefault()
    $('.calendar').toggleClass('expand')

  viewport: =>
    if typeof window.innerWidth is 'undefined'
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    else
      width: window.innerWidth
      height: window.innerHeight

$(document).ready ->
  window.app = new Main

module.exports = Main