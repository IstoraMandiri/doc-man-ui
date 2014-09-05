ZOOM_CLASS = 'docman-zoomed-in'
ZOOM_THREASHOLD = 1.6
pageStore = new ReactiveDict
handler = null

Template.docManSwipeView.helpers
  'currentPageNumber' : -> pageStore.get @_id
  'pageThumb': -> @page(pageStore.get(@_id))?.thumbnail('regular')

movePages = (docId, dir) ->
  currentPage = pageStore.get docId
  maxPages = pageStore.get "#{docId}_pages"
  nextPage = currentPage + dir
  if nextPage > 0 and nextPage <= maxPages
    pageStore.set docId, nextPage

Template.docManSwipeView.rendered = ->
  pageStore.set @data._id, 1

  handler = Deps.autorun =>
    pageStore.set "#{@data._id}_pages", @data.pageCount

  self = @
  $image = $(@find('img.doc-man-page'))

  page = -> self.data.page pageStore.get self.data._id

  # precache next page
  do preCacheNextPage = ->
    nextPage = self.data.page(pageStore.get(self.data._id)+1)?.thumbnail('regular')
    if nextPage?
      $("<img src='#{nextPage}'>")

  resetZoom = ->
    $image.panzoom('reset', {animate: false})
    setTimeout ->
      $image.removeClass ZOOM_CLASS
    , 10

  $image.hammer().on 'swipe', (e) ->
    if $image.panzoom("getMatrix")[0] < ZOOM_THREASHOLD # prevent accidental swiping
      if e.gesture.direction is 'left'
        resetZoom()
        movePages self.data._id, 1
        preCacheNextPage()

      else if e.gesture.direction is 'right'
        resetZoom()
        movePages self.data._id, -1

  .panzoom
    minScale: 1
    maxScale: 5
    contain: 'invert'

  .on 'panzoomend', (e,panzoom,matrix) ->
    console.log $image.panzoom("getMatrix")[0]
    if matrix[0] >= ZOOM_THREASHOLD and !$image.hasClass(ZOOM_CLASS)
      $image.addClass(ZOOM_CLASS)
      bigSrc = page().thumbnail('large')
      $("<img src='#{bigSrc}'>").load ->
        # prevent slow-loading pages from replacing current
        if bigSrc is page().thumbnail('large')
          $image.attr('src', bigSrc)

Template.docManSwipeView.destroyed = ->
  handler.stop()

