#import "../config/constants.typ": chapter
#let config(
    myAuthor: "Nome cognome",
    myTitle: "Titolo",
    myLang: "it",
    myNumbering: "1.",
    body
) = {
  // Set the document's basic properties.
    set document(author: myAuthor, title: myTitle)
    show math.equation: set text(weight: 400)

    // LaTeX look (secondo la doc di Typst)
    set page(margin: 1.75in, numbering: myNumbering, number-align: center)
    // set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
    set par(
        leading: 0.55em,
        spacing: 0.55em,
        first-line-indent: 1.8em,
        justify: true)
    set text(font: "New Computer Modern", size: 10pt, lang: myLang)
    set heading(numbering: myNumbering)
    show raw: set text(size: 10pt, lang: myLang)
    //show par: set block(spacing: 0.55em)
    set par(spacing: 0.55em)
    show heading: set block(above: 1.4em, below: 1em)


    show heading.where(level: 1): it => {
        stack(
            spacing: 2em,
            if it.numbering != none {
                text(size: 1.5em)[#chapter #counter(heading).display()]
            },
            text(size:2em,it.body),
            []
        )
    }

    // Regola per formattare elegantemente tutti i blocchi di codice
    show raw.where(block: true): it => block(
        fill: luma(250),                  // Sfondo grigio chiarissimo
        stroke: 0.5pt + luma(200),        // Bordino sottile e sobrio
        inset: 1em,                       // Margine interno (padding)
        radius: 4pt,                      // Angoli leggermente smussati
        width: 100%,                      // Occupa tutta la larghezza disponibile
        [
            #set text(size: 0.85em)         // Riduce leggermente la dimensione del font
            #it
        ]
    )

  body
}

#let useCase(useCaseDetails) = {
    let n = 1
    if useCaseDetails.number != "" and useCaseDetails.name != "" {
        text(12pt, [ *UC#useCaseDetails.number: #useCaseDetails.name* ])
    }
    let result = for (k, v) in useCaseDetails {
        if k != "number" and k != "name" {
            (text(k, weight: "bold"),
            v,)
        }
        n = n + 1
    }
    table(
        inset: 8pt,
        stroke: none,
        columns: 2,
        ..result
    )
}