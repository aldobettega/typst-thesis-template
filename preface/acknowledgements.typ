#import "../config/variables.typ" : profTitle, myProf, myLocation, myTime, myName
#import "../config/constants.typ" : acknowledgements

#set par(first-line-indent: 0pt)
#set page(numbering: "i")

#align(right, [
    #text(style: "italic", "cit...")
    #v(6pt)
])

#v(10em)

#text(24pt, weight: "semibold", acknowledgements)

#v(3em)

#text(style: "italic", "Innanzitutto, vorrei esprimere la mia gratitudine alla " + profTitle + myProf + " relatrice della mia tesi, per l'aiuto e il sostegno fornitomi durante la stesura del lavoro.")

#linebreak()

#text(style: "italic", "Desidero ringraziare ...")

#linebreak()

#text(style: "italic", "Ringrazio anche...")

#v(2em)

#text(style: "italic", myLocation + ", " + myTime + h(1fr) + myName)

#v(1fr)