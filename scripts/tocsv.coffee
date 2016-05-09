fs = require 'fs'
d3 = require 'd3'

folios = {
  "45c1f2b8-885e-4e2b-bc73-9ce6fa8bc1a5": '149r',
  "34066a49-7360-4c66-b042-dd008036a105": '149v',
  "cab4590d-692d-449c-8afc-1fc4285da169": '150r',
  "5af44c74-187f-47c4-a2e9-bc724d6ebca5": '150v',
  "6876bccf-cf6f-4ca3-ab1d-988021d5c5bf": '151r',
  "4c018cf9-31f4-4d9f-ae23-46a484b2223a": '151v',

}

marks = JSON.parse fs.readFileSync('marks.json').toString()
simples = []
marks.forEach (mark) ->
  if mark.createdAt > +new Date('1/1/2016')
    console.log JSON.stringify(mark, null, 2)
    simple = {
      author: mark.author
      intervention: mark.intervention
      value: mark.value
      folio: folios[mark.folioId]
      x: mark.x
      y: mark.y
    }
    simples.push simple

csv = d3.csv.format(simples)
fs.writeFileSync 'out.csv', csv

