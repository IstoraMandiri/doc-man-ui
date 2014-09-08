Package.describe({
  summary: "UI Elements for hitchcott:docman",
  version: "1.0.0",
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
    'tap:doc-man@1.1.1',
    'hitchcott:panzoom@1.0.1',
    'noorderstorm:hammer'
  ], ['client'])

  api.addFiles([
    'docman-ui.html',
    'docman-ui.coffee',
    'docman-ui.less'
  ], 'client')

});