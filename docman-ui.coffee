ZOOM_CLASS = 'docman-zoomed-in'
ZOOM_THREASHOLD = 1.6
pageStore = new ReactiveDict
handler = null

Template.docManSwipeView.helpers
  'currentPageNumber' : -> pageStore.get @doc._id
  'pageThumb': ->
    if @doc?.page
      @doc.page(pageStore.get(@doc._id))?.thumbnail('regular')

Template.docManSwipeView.events
  'mousedown .next-page, touchstart .next-page' : (e,tmpl) -> movePages @doc, 1, $(tmpl.find('img.doc-man-page'))
  'mousedown .prev-page, touchstart .prev-page' : (e,tmpl) -> movePages @doc, -1, $(tmpl.find('img.doc-man-page'))

resetZoom = ($image) ->
  $image.panzoom('reset', {animate: false})
  setTimeout ->
    $image.removeClass ZOOM_CLASS
  , 10

preCacheNextPage = (doc) ->
  nextPage = doc.page(pageStore.get(doc._id)+1)?.thumbnail('regular')
  if nextPage?
    $("<img src='#{nextPage}'>")

movePages = (doc, dir, $image) ->
  currentPage = pageStore.get doc._id
  maxPages = pageStore.get "#{doc._id}_pages"
  nextPage = currentPage + dir
  if nextPage > 0 and nextPage <= maxPages
    pageStore.set doc._id, nextPage
    resetZoom $image
    preCacheNextPage doc

Template.docManSwipeView.rendered = ->
  pageStore.set @data.doc._id, 1
  handler = Deps.autorun =>
    pageStore.set "#{@data.doc._id}_pages", @data.doc.pageCount

  self = @
  $container = $(@find('.doc-man-swipe-view'))
  $image = $(@find('img.doc-man-page'))

  page = -> self.data.doc.page pageStore.get self.data.doc._id

  preCacheNextPage self.data.doc

  swipeEvent = (e) ->
    e.stopPropagation()
    if $image.panzoom("getMatrix")[0] < ZOOM_THREASHOLD # prevent accidental swiping
      if e.gesture.direction is 'left'
        movePages self.data.doc, 1, $image

      else if e.gesture.direction is 'right'
        movePages self.data.doc, -1, $image

  $container.hammer().on 'swipe', swipeEvent
  $image.hammer().on 'swipe', swipeEvent
  .panzoom
    minScale: 1
    maxScale: 5
    contain: 'invert'

  .on 'panzoomend', (e,panzoom,matrix) ->
    if matrix[0] >= ZOOM_THREASHOLD and !$image.hasClass(ZOOM_CLASS)
      $image.addClass(ZOOM_CLASS)
      bigSrc = page().thumbnail('large')
      $("<img src='#{bigSrc}'>").load ->
        # prevent slow-loading pages from replacing current
        if bigSrc is page().thumbnail('large')
          $image.attr('src', bigSrc)

Template.docManSwipeView.destroyed = ->
  handler.stop()

