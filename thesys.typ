#import "./config/variables.typ": *
#import "./config/thesis-config.typ": *

#import "@preview/glossarium:0.5.1": make-glossary, register-glossary
#import "./config/glossario-data.typ": mio-glossario

#show: config.with(
  myAuthor: myName,
  myTitle: myTitle,
  myNumbering: "1.",
  myLang: myLang
)

#include "structure.typ"