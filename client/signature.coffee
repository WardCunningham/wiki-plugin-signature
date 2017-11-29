
expand = (text) ->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\*(.+?)\*/g, '<i>$1</i>'

check = ($item) ->
  # https://www.npmjs.com/package/object-hash ?
  sum = 0
  page = $item.parents('.page').data('data')
  for item in page.story
    sum *= 3
    if item.type == 'signature'
      sum += item.text.length
    else
      sum += JSON.stringify(item).length
    sum %= 1000000
  sum

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
    sum = check $item
    item.algo = 'trivial'
    item.signatures ||= {}
    item.signatures[location.host] ||= {}
    item.signatures[location.host][sum] = {sum, date}
    $item.empty()
    emit $item, item
    bind $item, item
    update()


window.plugins.signature = {emit, bind} if window?
module.exports = {expand} if module?

