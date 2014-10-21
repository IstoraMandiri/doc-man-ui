Package.describe({
  summary: "UI Elements for tap:doc-man",
  version: "1.1.0",
  name: 'tap:doc-man-ui'
});

Package.onUse(function(api) {
  if(api.versionsFrom) {
    api.versionsFrom('METEOR@0.9.0');
  }

  api.use([
    'coffeescript',
    'less',
    'templating',
    'reactive-dict',
    'tap:doc-man@1.1.2',
    'hitchcott:panzoom@1.0.1',
    'noorderstorm:hammer'
  ], ['client'])

  api.addFiles([
    'docman-ui.html',
    'docman-ui.coffee',
    'docman-ui.less'
  ], 'client')

});