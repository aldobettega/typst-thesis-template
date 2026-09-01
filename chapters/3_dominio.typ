#import "../config/glossario-data.typ": gls

#pagebreak(to:"odd")

= Studio del dominio

Durante la prima fase del tirocinio è stato fatto uno studio approfondito sul tema del #gls("vulnerability-assessment"), attraverso il quale sono stati compresi i termini chiave del dominio, le principali problematiche e le soluzioni che le aziende prendono in considerazione per gestire al meglio il tracciamento e risoluzione di vulnerabilità.
Come riporta @rajamani2025, nel solo 2025 sono state pubblicate 48.185 #gls("cve"), di cui il 56% classificate come #emph("high") o #emph("critical"), rendendo la coda di #gls("remediation") ingestibile senza un #gls("triage") intelligente.
Questa eccessiva segnalazione di vulnerabilità porta ad un fenomeno chiamato #gls("vulnerability-fatigue") che induce gli analisti a non svolgere in modo efficace la loro gestione.
Per questo motivo occorre adottare un framework #gls("ctem") (#emph("Continuous Threat Exposure Management")) e affidarsi ad un ampio ventaglio di metriche per poter constestualizzare al meglio le #gls("cve") ed ottimizzare la loro risuluzione, dando priorità ad un ristretto e mirato numero di vulnerabilità.

La piattaforma di ThreatLens si sviluppa in questo contesto e intende ottenere da un indirizzo #gls("ip") una lista di #gls("cve") utilizzando scanner professionali di terze parti come #gls("qualys"), alla quale aggiunge una serie di altre metriche fornendo un dettagliato e attendibile contesto facilmente interpretabile da un analista di sicurezza.
La piattaforma funge da motore di prioritizzazione intelligente: valuta il rischio operativo di ogni singola #gls("cve") e impiega l'Intelligenza Artificiale per generare una spiegazione chiara e sintetica delle metriche rilevate. In questo modo, il sistema non si sostituisce all'analista nella decisione finale, ma gli fornisce un quadro contestualizzato e argomentato, permettendogli di validare rapidamente le informazioni proposte e procedere in modo tempestivo con la corretta #gls("remediation").

== Limiti del CVSS

La metrica principale per classificare una #gls("cve") è il #gls("cvss"), uno standard sviluppato dal #gls("first") che indica da 1.0 a 10.0 la gravità di una vulnerabilità.
Questa metrica tuttavia risponde alla domanda sbagliata per il #gls("triage"): dice quanto sarebbe grave una vulnerabilità se sfruttata, non quanto è probabile che venga sfruttata in tempi utili per decidere il #gls("patching").
In @VMC viene detto che la metrica #gls("cvss") è stata creata solo per misurare il massimo impatto teorico possibile invece di un rischio nel mondo reale. Infatti non considera la probabilità che essa venga usata e il rischio pesato in un preciso contesto.
Già da tempo ci sono articoli come @ImprovingCvss che indicano come i punteggi #gls("cvss"), senza informazione sull'ambiente in cui si presenta la vulnerabilità, hanno utilità limitata per una prioritizzazione pratica. Inoltre aggiungere del contesto migliorerebbe significativamente la selezione delle risposte.

Un secondo problema di questa metrica è la scarsa azionabilità del punteggio. Il #gls("cvss") concentra molte vulnerabilità nelle fasce alte, con uno score superiore al 7.0, rendendo difficile la priorità di #emph("remediation") e aumentando il fenomeno di #gls("vulnerability-fatigue").

== Nuove metriche supportate dalla letteratura scientifica

La soluzione sarebbe integrare nella prioritizzazione una serie di altre metriche per sopperire ai problemi sopra descritti. 
Un dato significativo è l'#gls("epss") che utilizza il machine learning e #emph("threat intelligence data") per stimare la probabilità che una vulnerabilità venga sfruttata entro 30 giorni, mentre il #gls("kev") indica se sono state registrate evidenze di #emph[#gls("exploit")] confermato.
Secondo @VMC, mentre un filtro basato esclusivamente sul #gls("cvss") presenta un'efficienza operativa di appena lo 0,5% (generando un elevato rumore di fondo), il modello combinato innalza la precisione al 9,1%. Questo permette di concentrare gli sforzi operativi sulle minacce reali, mantenendo al contempo una copertura (#emph("coverage")) dell'85,6% sulle vulnerabilità effettivamente sfruttate.

#v(1em)

#table(
  // La prima colonna prende lo spazio disponibile, le altre due si adattano al contenuto
  columns: (1fr, auto, auto),
  
  // Allineamento: a sinistra per il metodo, centrato per le percentuali
  align: (col, row) => if col == 0 { left + horizon } else { center + horizon },
  
  // Sfondo dell'intestazione (ottanio)
  fill: (col, row) => if row == 0 { rgb("007373") } else { none },
  
  // Bordo della tabella
  stroke: 0.5pt + black,
  
  // -- INTESTAZIONE --
  text(fill: white, weight: "bold")[Method], 
  text(fill: white, weight: "bold")[Efficiency],
  text(fill: white, weight: "bold")[Coverage],
  
  // -- RIGHE --
  [CVSS $>= 7.0$], 
  [0.5%], 
  [90.0%],
  
  [KEV Only], 
  [74.3%], 
  [86.7%],
  
  [EPSS $>= 0.088$], 
  [4.9%], 
  [48.9%],
  
  // Sostituito vee/wedge con or/and
  [*Proposed Method* \ *(KEV $or$ EPSS) $and$ CVSS*], 
  [*9.1%*], 
  [*85.6%*]
)

#v(1em)


== Il modello Vulnerability Management Chaining

Nel paper di @VMC si dimostra come combinare #gls("cvss"), #gls("epss") e #gls("kev") dia un risultato molto più accurato.
Lo studio definisce il #emph("Vulnerability Management Chaining"), un albero decisionale (#emph[#gls("decision-tree")]) che prende in input questi tre dati e restituisce una priorità da assegnare alla #gls("cve").

#figure(
    image("../images/VMCDiagram.png"),
    caption: [#emph("Vulnerability Management Chaining Decision Tree"), da @VMC ]
)
\ \ 
Questo albero presenta due stadi principali:

+ Nello stadio uno viene controllata la reale minaccia e si passa allo stadio successivo se e solo se uno di questi due valori è vero:
    - è presente nel catalogo del #gls("kev")?
    - ha un #gls("epss") alto (maggiore di 0.0888)?

+ Se si arriva allo stadio due, la minaccia è probabile, dunque si valuta quanto sarebbe grave nel peggior caso possibile: se ha un #gls("cvss") maggiore di 7.0 è di priorità massima.

Dal #emph[#gls("decision-tree")] possono essere prodotti in output 4 risultati:


#v(1em)

#table(
  // La prima colonna si adatta al testo (auto), la seconda prende tutto lo spazio rimanente (1fr)
  columns: (auto, 1fr),
  
  // Allineamento: centrato per i nomi delle priorità, a sinistra per le condizioni logiche
  align: (col, row) => if col == 0 { center + horizon } else { left + horizon },
  
  // Sfondo dell'intestazione (ottanio)
  fill: (col, row) => if row == 0 { rgb("007373") } else { none },
  
  // Bordo della tabella
  stroke: 0.5pt + black,
  
  // -- INTESTAZIONE --
  text(fill: white, weight: "bold")[Classe di Priorità], 
  text(fill: white, weight: "bold")[Condizione Logica (Decision Tree)],
  
  // -- RIGHE --
  [*Critical*], 
  [KEV == `TRUE` AND CVSS $>= 7.0$],
  
  [*High*], 
  [EPSS $>= 0.0888$ AND CVSS $>= 7.0$ AND KEV == `FALSE`],
  
  [*Monitor*], 
  [(KEV == `TRUE` OR EPSS $>= 0.0888$) AND CVSS $< 7.0$],
  
  [*Defer*], 
  [KEV == `FALSE` AND EPSS $<= 0.0888$]
)

Nella piattaforma ThreatLens per la classificazione dell'esito finale, il sistema adotta la nomenclatura introdotta dal framework #gls("ssvc"). 

Questa scelta architetturale è motivata dal fatto che il modello #gls("ssvc") viene adottato come linguaggio di classificazione, in quanto progettato esplicitamente per categorizzare le decisioni di risposta attorno agli #emph[#gls("stakeholder")], alle azioni di mitigazione e alla tolleranza al rischio dell'organizzazione.
Come riporta la documentazione ufficale di CISA in @cisa_ssvc:
#align(center)[
  #block(
    fill: luma(250),
    stroke: (left: 2pt + luma(150)),
    inset: (left: 1.5em, right: 1em, top: 1em, bottom: 1em),
    width: 95%,
    align(left)[
      #set text(style: "italic", size: 0.95em)
      
      CISA uses its own SSVC decision tree model to prioritize relevant vulnerabilities into four possible decisions: 
      
      - *Track:* The vulnerability does not require action at this time. The organization would continue to track the vulnerability and reassess it if new information becomes available. CISA recommends remediating Track vulnerabilities within standard update timelines. 
      - *Track\*:* The vulnerability contains specific characteristics that may require closer monitoring for changes. CISA recommends remediating Track\* vulnerabilities within standard update timelines. 
      - *Attend:* The vulnerability requires attention from the organization's internal, supervisory-level individuals. Necessary actions include requesting assistance or information about the vulnerability, and may involve publishing a notification either internally and/or externally. CISA recommends remediating Attend vulnerabilities sooner than standard update timelines. 
      - *Act:* The vulnerability requires attention from the organization's internal, supervisory-level and leadership-level individuals. Necessary actions include requesting assistance or information about the vulnerability, as well as publishing a notification either internally and/or externally. Typically, internal groups would meet to determine the overall response and then execute agreed upon actions. CISA recommends remediating Act vulnerabilities as soon as possible.
    ]
  )
]


Di conseguenza, gli esiti dell'elaborazione algoritmica vengono mappati sulle seguenti categorie d'azione standardizzate:
- `TRACK`
- `TRACK*`
- `ATTEND`
- `ACT`

#v(1em)


=== Analisi teorica del funzionamento

I tre dati da soli forniscono poche informazioni, ma combinati si compensano tra di loro, dando un contesto più completo:

- il #gls("kev") ha un alta confidenza (se presente nel database è un dato molto rilevante), ma ha una copertura limitata e una natura reattiva (non prevede rischi potenzialmente gravi).
- l'#gls("epss") ha una forte copertura predittiva, ma proprio per questo è un dato probabilistico con alta incertezza che produce falsi positivi e falsi negativi.
- il #gls("cvss") valuta l'impatto potenziale in modo accurato, ma non indica se la vulnerabilità sarà realmente sfruttata.

Questo framework adotta un approccio #emph("threat-first"): come riporta @VMC le vulnerabilità realmente sfruttate rispetto alle #gls("cve") pubblicate sono in numero molto minore. Per questo l'algoritmo parte valutando le vulnerabilità che sono realmente una minaccia. 

=== Parametrizzazione dei valori

Le sogle citate sopra per #gls("cvss") e #gls("epss") sono dei parametri indicati da @VMC che ha condotto un'analisi usando un dataset di 28.377 #gls("cve"). Lo studio dimostra come questi specifici valori siano statisticamente ottimali per segmentare le minacce in classi operative distinte.

Tuttava indica che questi valori possono essere dei parametri flessibili ed è possibile configurarli in funzione del profilo di tolleranza che si vuole ottenere.
Se per esempio ci si trova in un ambiente particolarmente critico ed è necessario prendere in considerazione anche delle vulnerabilità con valori di gravità minore, si abbassa la soglia #gls("epss").
Se un'organizzazione ha meno risorse da allocare per il #gls("vulnerability-assessment"), si può decidere di alzare la soglia accettando un rischio maggiore, al fine di isolare un quantitativo minore di vulnerabilità da gestire.

In ThreatLens è stato deciso di inserire nell'algoritmo le soglie indicate statisticamente ottimali da @VMC. Tuttavia, a fronte delle considerazioni sopracitate, è stato preso in considerazione come futuro sviluppo una configurazione dall'interfaccia web del calcolo della priorità. Questa implementazione consentirà all'analista di selezionare queste soglie calibrando l'algoritmo per adattare i risultati allo specifico contesto operativo e alla toleranza al rischio della propria organizzazione.