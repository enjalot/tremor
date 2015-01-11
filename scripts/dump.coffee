console.log process.argv
name = process.argv[2]

require '../server/config'
fs = require 'fs'

# setup the database
liveDbMongo = require 'livedb-mongo'
derby = require 'derby'
mongo = liveDbMongo process.env.MONGO_URL + '?auto_reconnect', {safe: true}
store = derby.createStore db: mongo
model = store.createModel()


if !name
  query = model.query "manuscripts", {}
  query.fetch ->
    for mani in query.get()
      console.log mani

    console.log "run with manuscript id to dump marks"
    process.exit()
else
  query = model.query "marks", {manuscriptId: name}
  query.fetch ->
    marks = query.get()
    console.log "# marks", marks.length
    str = JSON.stringify(marks)
    fs.writeFileSync './marks.json', str

    process.exit()