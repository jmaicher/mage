deps = []

module = angular.module('mage.desktop.filter', deps)

module.filter 'highlight', ($sce) ->
  return (text, phrase) ->
    if (phrase)
      text = text.replace(new RegExp('('+phrase+')', 'gi'), '<span class="highlighted">$1</span>')
    return $sce.trustAsHtml(text)
