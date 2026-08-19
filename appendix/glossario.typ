// File: appendix/glossario.typ

#import "../config/glossario-data.typ": mio-glossario

= Glossario

#set par(first-line-indent: 0pt)
#show terms: set block(above: 1.5em, below: 1.5em)

// Ordiniamo in base al nuovo campo "parola"
#let glossario-ordinato = mio-glossario.sorted(key: voce => voce.parola)

#for voce in glossario-ordinato [
  / #voce.parola: #voce.desc #label(voce.key)
]