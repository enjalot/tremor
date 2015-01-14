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
  marksQuery = model.query "marks", {manuscriptId: name}
  foliosQuery = model.query "folios", {manuscriptId: name}
  model.fetch marksQuery, foliosQuery, ->
    marks = marksQuery.get()
    console.log "# marks", marks.length
    str = JSON.stringify(marks)
    fs.writeFileSync './marks.json', str
    folios = model.get("folios")
    str = JSON.stringify(folios)
    fs.writeFileSync './folios.json', str

    process.exit()