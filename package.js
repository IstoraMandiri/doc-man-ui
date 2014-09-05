Package.describe({
  summary: "UI Elements for hitchcott:docman",
  version: "1.0.0",
  name: 'hitchcott:docman-ui'
});

Package.onUse(function(api) {
  if(api.versionsFrom) {
    api.versionsFrom('METEOR@0.9.0');
  }

  api.use([
    'coffeescript',
    'less',
    'templating',
    'hitchcott:docman',
    'hitchcott:panzoom'
  ], ['client'])

  api.addFiles([
    'docman-ui.html',
    'docman-ui.coffee',
    'docman-ui.less'
  ], 'client')

});