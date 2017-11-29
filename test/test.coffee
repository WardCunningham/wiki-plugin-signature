# build time tests for signature plugin
# see http://mochajs.org/

signature = require '../client/signature'
expect = require 'expect.js'

describe 'signature plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = signature.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
