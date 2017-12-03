
crypto = require 'crypto'

expand = (text) ->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'

page = ($item) ->
  $item.parents('.page').data('data')

check = ($item) ->
  # https://www.npmjs.com/package/object-hash ?
  # https://docs.nodejitsu.com/articles/cryptography/how-to-use-crypto-module/

  sum = crypto.createHash 'md5'
  for item in page($item).story
    if item.type == 'signature'
      sum.update item.text
    else
      sum.update JSON.stringify(item)
  sum.digest 'hex'

emit = ($item, item) ->

  sum = check $item

  status = (sigs) ->
    if sigs[sum]
      "<td style=\"color: #3f3; text-align: right;\">valid"
    else
      "<td style=\"color: #f88; text-align: right;\">invalid"


  report = ->
    for site, sigs of item.signatures || {}
      "<tr>#{status sigs}<td>#{site}"

  $item.append """
    <div style="background-color:#eee; padding:8px;">
      <center>
        #{expand item.text}
        <table style="background-color:#f8f8f8; margin:8px; padding:8px; min-width:70%">
          #{report().join('')}
        </table>
        <button>sign</button>
      </center>
    </div>
  """

bind = ($item, item) ->

  update = ->
    wiki.pageHandler.put $item.parents('.page:first'),
      type: 'edit',
      id: item.id,
      item: item

  $item.dblclick -> wiki.textEditor $item, item

  $item.find('button').click ->
    date = Date.now()
    rev = page($item).journal.length-1
    algo = 'trivial'
    sum = check $item
    item.signatures ||= {}
    item.signatures[location.host] ||= {}
    item.signatures[location.host][sum] = {date, rev, algo, sum}
    $item.empty()
    emit $item, item
    bind $item, item
    update()


window.plugins.signature = {emit, bind} if window?
module.exports = {expand} if module?

