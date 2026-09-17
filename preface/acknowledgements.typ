#pagebreak(weak: true, to: "odd")
#import "../config/variables.typ" : profTitle, myProf, myLocation, myTime, myName
#import "../config/constants.typ" : acknowledgements

#set par(first-line-indent: 0pt)
#set page(numbering: "i")

#v(10em)

#text(24pt, weight: "semibold", acknowledgements)

#v(3em)

#text(style: "italic", "Innanzitutto, vorrei esprimere la mia gratitudine alla " + profTitle + myProf + ", relatrice della mia tesi, per l'aiuto e il sostegno fornitomi durante la stesura del lavoro.")

#linebreak()

#text(style: "italic", "Desidero ringraziare l'azienda Kirey Group e i professionisti con cui ho avuto il piacere di lavorare, i quali hanno reso possibile la creazione del progetto ThreatLens.")

#linebreak()

#text(style: "italic", "Un ringraziamento speciale va ai miei genitori per il fondamentale sostegno lungo questo percorso, e alla mia famiglia e ai miei fratelli per i momenti passati insieme. Ringrazio Maria per essermi stata sempre vicina e avermi supportato. Un ultimo pensiero è rivolto ai miei amici, per le significative esperienze condivise, e ai miei compagni universitari Marco e Paolo, per il prezioso aiuto in questi anni di studi.")


#v(2em)

#text(style: "italic", myLocation + ", " + myTime + h(1fr) + myName)

#v(1fr)