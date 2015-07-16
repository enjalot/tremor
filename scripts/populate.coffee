console.log process.argv
name = process.argv[2]
num = process.argv[3]

if !name
  console.log "provide a name"

if !num
  console.log "provide a number of folios"

require '../server/config'

# setup the database
liveDbMongo = require 'livedb-mongo'
derby = require 'derby'
mongo = liveDbMongo process.env.MONGO_URL + '?auto_reconnect', {safe: true}
store = derby.createStore db: mongo
model = store.createModel()

path = "manuscripts.#{name}"
model.fetch path, ->
  if !model.get path
    model.add "manuscripts", {id: name, createdAt: +new Date(), folios: +num}

  [1..num].forEach (i) ->
    # create a folio
    model.add "folios", {manuscriptId: name, side: 'r', index: i}
    model.add "folios", {manuscriptId: name, side: 'v', index: i}
    console.log "created folio #{i}"

  model.whenNothingPending ->
    process.exit()
